//
//  InternetGalleryViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 03/10/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit

class InternetGalleryViewController: UIViewController {
    
    var delegate: InternetGalleryViewControllerDelegate?
    
    private lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let screenRatio = view.frame.height / view.frame.width
        let cellWidth = view.frame.width * 0.31
        let cellHeight = cellWidth * screenRatio
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = 3.0
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "image cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search an image"
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var unsplashLabel: UILabel = {
        let label = UILabel()
        label.text = "Powered by Unsplash"
        label.font = label.font.withSize(10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var progressAlertController: UIAlertController = {
        let alertController = UIAlertController(title: nil, message: "Downloading the image\n\n", preferredStyle: .alert)
        
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.center = CGPoint(x: 135.0, y: 65.5)
        indicator.color = UIColor.black
        indicator.startAnimating()
        
        alertController.view.addSubview(indicator)
        
        return alertController
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.startAnimating()
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var errorAlertController: UIAlertController = {
        let alertController = UIAlertController(title: "There was a problem", message: "Check your Internet connection.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        return alertController
    }()
    
    private var imagesRequest = ImagesRequest()
    
    private var internetImages = [InternetImage]() {
        didSet {
            DispatchQueue.main.async {
                self.imagesCollectionView.reloadData()
            }
        }
    }
    
    private var imageCache = NSCache<NSURL, UIImage>()
    
    private var currentPage = 1
    private var fetchedPages = [1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(unsplashLabel)
        view.addSubview(imagesCollectionView)
        view.addSubview(activityIndicator)
    }
    
    private func addConstraints() {
        addSearchBarConstraints()
        addUnsplashLabelConstraints()
        addImagesCollectionViewConstraints()
        addActivityIndicatorViewConstraints()
    }
    
    private func addSearchBarConstraints() {
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func addUnsplashLabelConstraints() {
        unsplashLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        unsplashLabel.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -16).isActive = true
    }
    
    private func addImagesCollectionViewConstraints() {
        imagesCollectionView.topAnchor.constraint(equalTo: unsplashLabel.bottomAnchor, constant: 8).isActive = true
        imagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        imagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
    }
    
    private func addActivityIndicatorViewConstraints() {
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func fetchImages() {
        imagesRequest.getImages(with: searchBar.text ?? "", for: currentPage) { [weak self] result in
            switch result {
            case .failure( _):
                self?.presentErrorAlertController()
            case .success(let images):
                self?.appendDownloadedImages(images)
            }
            self?.hideActivityIndicator()
        }
    }
    
    private func hideActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = true
        }
    }
    
    private func showActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.isHidden = false
        }
    }
    
    private func presentErrorAlertController() {
        DispatchQueue.main.async { [weak self] in
            self?.present(self!.errorAlertController, animated: true)
        }
    }
    
    private func appendDownloadedImages(_ images: [InternetImage]) {
        internetImages += images
    }
}

// MARK:  UICollectionView delegate

extension InternetGalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentProgressAlertController()
        downloadImageAndPassItBack(from: indexPath)
    }
    
    private func presentProgressAlertController() {
        present(progressAlertController, animated: true)
    }
    
    private func downloadImageAndPassItBack(from indexPath: IndexPath) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let url = self?.getRegularImageURL(for: indexPath) else {
                self?.presentErrorAlertController()
                return
            }
            guard let urlContents = url.getData() else {
                self?.presentErrorAlertController()
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.hideProgressAlertControllerAndPassTheImageBack(with: urlContents)
            }
        }
    }
    
    private func getRegularImageURL(for indexPath: IndexPath) -> URL? {
        return URL(string: (internetImages[indexPath.row].urls.regular))
    }
    
    private func hideProgressAlertControllerAndPassTheImageBack(with imageData: Data) {
        progressAlertController.dismiss(animated: true, completion: {
            self.delegate?.onImageChosenFromTheInternet(UIImage(data: imageData)!)
            self.navigationController?.popViewController(animated: true)
        })
    }
}

// MARK:  UICollectionView data source

extension InternetGalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return internetImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fetchNextImagesIfAtTheEnd(indexPath)
        let cell = getReusableImageCellAndClearCurrentImage(from: collectionView, for: indexPath)
        setImageOnCell(cell: cell, on: indexPath)
        return cell
    }
    
    private func fetchNextImagesIfAtTheEnd(_ indexPath: IndexPath) {
        if isIndexPathTheLastInPage(indexPath) {
            if !wasPageAlreadyFetched(at: indexPath) {
                currentPage += 1
                fetchedPages += [currentPage]
                fetchImages()
            }
        }
    }
    
    private func isIndexPathTheLastInPage(_ indexPath: IndexPath) -> Bool {
        return indexPath.row % (imagesRequest.imagesPerPage - 1) == 0  && indexPath.row != 0
    }
    
    private func wasPageAlreadyFetched(at indexPath: IndexPath) -> Bool {
        let pageForIndex = indexPath.row / (imagesRequest.imagesPerPage - 1)
        return fetchedPages.contains(pageForIndex + 1)
    }
    
    private func getReusableImageCellAndClearCurrentImage(from collectionView: UICollectionView, for indexPath: IndexPath) -> ImageCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "image cell", for: indexPath) as? ImageCell ?? ImageCell()
        cell.clearImage()
        return cell
    }
    
    private func setImageOnCell(cell: ImageCell, on indexPath: IndexPath) {
        guard let url = getSmallImageURL(for: indexPath) else {
            return
        }
        if let cachedImage = getCachedImageIfPresent(for: url) {
            cell.setImage(image: cachedImage)
        } else {
            fetchImageFromTheInternetAndUpdateCell(with: url, from: indexPath, cell: cell)
        }
    }
    
    private func getSmallImageURL(for indexPath: IndexPath) -> URL? {
        return URL(string: (internetImages[indexPath.row].urls.small))
    }
    
    private func getCachedImageIfPresent(for url: URL) -> UIImage? {
        return imageCache.object(forKey: url as NSURL)
    }
    
    private func fetchImageFromTheInternetAndUpdateCell(with url: URL, from indexPath: IndexPath, cell: ImageCell) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let urlContents = url.getData() else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.updateCellImageAndCacheIt(cell: cell, with: urlContents, for: indexPath)
            }
        }
    }
    
    private func updateCellImageAndCacheIt(cell: ImageCell, with imageData: Data, for indexPath: IndexPath) {
        if internetImages.indices.contains(indexPath.row) {
            let smallUrlString = internetImages[indexPath.row].urls.small
            let image = UIImage(data: imageData)!
            cacheDownloadedImage(image: image, forKey: URL(string: smallUrlString)!)
            cell.setImage(image: image)
        } else {
            return
        }
    }
    
    private func cacheDownloadedImage(image: UIImage, forKey url: URL) {
        imageCache.setObject(image, forKey: url as NSURL)
    }
}

// MARK:  UISearchBar delegate

extension InternetGalleryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
        showActivityIndicator()
        internetImages = []
        fetchedPages = []
        currentPage = 1
        fetchImages()
    }
    
    private func hideKeyboard() {
        searchBar.resignFirstResponder()
    }
}

protocol InternetGalleryViewControllerDelegate {
    func onImageChosenFromTheInternet(_ image: UIImage)
}
