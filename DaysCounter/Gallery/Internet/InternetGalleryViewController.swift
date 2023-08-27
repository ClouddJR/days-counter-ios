import UIKit

class InternetGalleryViewController: UIViewController {
    var delegate: InternetGalleryDelegate?
    
    private lazy var imagesCollectionView: UICollectionView = {
        let screenRatio = max(view.frame.width, view.frame.height) / min(view.frame.width, view.frame.height)
        let cellWidth = min(view.frame.width, view.frame.height) * 0.31
        let cellHeight = cellWidth * screenRatio
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumInteritemSpacing = 3.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "image cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = NSLocalizedString("E.g. nature", comment: "")
        searchBar.searchBarStyle = .minimal
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
        let alertController = UIAlertController(
            title: nil,
            message: NSLocalizedString("Downloading the image\n\n", comment: ""),
            preferredStyle: .alert
        )
        
        let indicator = UIActivityIndicatorView()
        indicator.center = CGPoint(x: 135.0, y: 65.5)
        indicator.startAnimating()
        
        alertController.view.addSubview(indicator)
        
        return alertController
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.isHidden = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var errorAlertController: UIAlertController = {
        let alertController = UIAlertController(
            title: NSLocalizedString("Images Could Not Be Loaded", comment: ""),
            message: NSLocalizedString("Check your Internet connection.", comment: ""),
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        return alertController
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imagesRequest = ImagesRequest()
    
    private var internetImages = [InternetImage]() {
        didSet {
            DispatchQueue.main.async {
                self.imagesCollectionView.reloadData()
            }
        }
    }
    
    private let imageCache = NSCache<NSURL, UIImage>()
    
    private var currentPage = 1
    private var fetchedPages = [1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyStyling()
        addSubviews()
        addConstraints()
    }
    
    private func applyStyling() {
        navigationItem.title = NSLocalizedString("Search an image", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel)
        
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(unsplashLabel)
        view.addSubview(imagesCollectionView)
        view.addSubview(activityIndicator)
        view.addSubview(errorLabel)
    }
    
    private func addConstraints() {
        addSearchBarConstraints()
        addUnsplashLabelConstraints()
        addImagesCollectionViewConstraints()
        addActivityIndicatorViewConstraints()
        addErrorLabelConstraints()
    }
    
    private func addSearchBarConstraints() {
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func addUnsplashLabelConstraints() {
        unsplashLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        unsplashLabel.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: -16).isActive = true
    }
    
    private func addImagesCollectionViewConstraints() {
        imagesCollectionView.topAnchor.constraint(equalTo: unsplashLabel.bottomAnchor, constant: 8).isActive = true
        imagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imagesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        imagesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
    }
    
    private func addActivityIndicatorViewConstraints() {
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func addErrorLabelConstraints() {
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func fetchImages() {
        imagesRequest.getImages(with: searchBar.text ?? "", for: currentPage) { [weak self] result in
            switch result {
            case .failure( _):
                self?.presentErrorAlertController()
            case .success(let images):
                self?.displayPotentialInfoAboutNoImages(self!.currentPage, images)
                self?.internetImages += images
            }
            self?.hideActivityIndicator()
        }
    }
    
    private func presentErrorAlertController() {
        DispatchQueue.main.async { [weak self] in
            self?.present(self!.errorAlertController, animated: true)
        }
    }
    
    private func displayPotentialInfoAboutNoImages(_ currentPage: Int, _ images: [InternetImage]) {
        if currentPage == 1 && images.isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.errorLabel.text = NSLocalizedString("No images found", comment: "")
            }
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
}

extension InternetGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        present(progressAlertController, animated: true)
        downloadImageAndPassItBack(from: indexPath)
    }
    
    private func downloadImageAndPassItBack(from indexPath: IndexPath) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard
                let url = self?.getRegularImageURL(for: indexPath),
                let urlContents = url.getData()
            else {
                self?.presentErrorAlertController()
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.hideProgressAndPassTheImageBack(with: urlContents)
            }
        }
    }
    
    private func getRegularImageURL(for indexPath: IndexPath) -> URL? {
        return URL(string: (internetImages[indexPath.row].urls.regular))
    }
    
    private func hideProgressAndPassTheImageBack(with imageData: Data) {
        progressAlertController.dismiss(animated: true, completion: {
            self.delegate?.onInternetImageChosen(UIImage(data: imageData)!)
            self.navigationController?.dismiss(animated: true)
        })
    }
}

extension InternetGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return internetImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fetchNextImagesIfAtTheEnd(indexPath)
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "image cell", for: indexPath) as? ImageCell ?? ImageCell()
        cell.clearImage()
        updateImage(for: cell, on: indexPath)
        
        return cell
    }
    
    private func fetchNextImagesIfAtTheEnd(_ indexPath: IndexPath) {
        if !wasPageAlreadyFetched(at: indexPath) && isIndexPathTheLastInPage(indexPath) {
            currentPage += 1
            fetchedPages += [currentPage]
            fetchImages()
        }
    }
    
    private func wasPageAlreadyFetched(at indexPath: IndexPath) -> Bool {
        let pageForIndex = indexPath.row / (imagesRequest.imagesPerPage - 1)
        return fetchedPages.contains(pageForIndex + 1)
    }
    
    private func isIndexPathTheLastInPage(_ indexPath: IndexPath) -> Bool {
        return indexPath.row % (imagesRequest.imagesPerPage - 1) == 0  && indexPath.row != 0
    }
    
    private func updateImage(for cell: ImageCell, on indexPath: IndexPath) {
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
            guard let urlContents = url.getData() else { return }
            
            DispatchQueue.main.async { [weak self] in
                self?.updateCellImageAndCacheIt(cell: cell, with: urlContents, for: indexPath)
            }
        }
    }
    
    private func updateCellImageAndCacheIt(cell: ImageCell, with imageData: Data, for indexPath: IndexPath) {
        guard internetImages.indices.contains(indexPath.row) else { return }
        
        let image = UIImage(data: imageData)!
        let smallUrlString = internetImages[indexPath.row].urls.small
        cacheDownloadedImage(image: image, forKey: URL(string: smallUrlString)!)
        cell.setImage(image: image)
    }
    
    private func cacheDownloadedImage(image: UIImage, forKey url: URL) {
        imageCache.setObject(image, forKey: url as NSURL)
    }
}

extension InternetGalleryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        errorLabel.text = ""
        showActivityIndicator()
        internetImages = []
        fetchedPages = []
        currentPage = 1
        fetchImages()
    }
}

protocol InternetGalleryDelegate {
    func onInternetImageChosen(_ image: UIImage)
}
