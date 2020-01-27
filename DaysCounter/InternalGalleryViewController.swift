//
//  InternalGalleryViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 02/10/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit

class InternalGalleryViewController: UIViewController {
    
    var delegate: InternalGalleryViewControllerDelegate?
    
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
        collectionView.backgroundColor = view.backgroundColor
        return collectionView
    }()
    
    private let images = [
        #imageLiteral(resourceName: "nature1.jpg"),#imageLiteral(resourceName: "nature2.jpg"),#imageLiteral(resourceName: "nature3.jpg"),#imageLiteral(resourceName: "nature4.jpg"),#imageLiteral(resourceName: "nature5.jpg"),#imageLiteral(resourceName: "nature6.jpg"),#imageLiteral(resourceName: "nature7.jpg"),#imageLiteral(resourceName: "nature8.jpg"),#imageLiteral(resourceName: "nature9.jpg"),#imageLiteral(resourceName: "nature10.jpg"),#imageLiteral(resourceName: "nature11.jpg"),#imageLiteral(resourceName: "nature12.jpg"),#imageLiteral(resourceName: "nature13.jpg"),#imageLiteral(resourceName: "nature14.jpg"),#imageLiteral(resourceName: "nature15.jpg"),#imageLiteral(resourceName: "nature16.jpg"),#imageLiteral(resourceName: "nature17.jpg"),#imageLiteral(resourceName: "nature18.jpg"),#imageLiteral(resourceName: "birth1.jpg"),#imageLiteral(resourceName: "birth2.jpg"),#imageLiteral(resourceName: "birthday1.jpg"),#imageLiteral(resourceName: "birthday2.jpg"),#imageLiteral(resourceName: "birthday3.jpg"),#imageLiteral(resourceName: "book1.jpg"),#imageLiteral(resourceName: "book2.jpg"),#imageLiteral(resourceName: "book3.jpg"),#imageLiteral(resourceName: "book4.jpg"),#imageLiteral(resourceName: "book5.jpg"),#imageLiteral(resourceName: "book6.jpg"),#imageLiteral(resourceName: "book7.jpg"),#imageLiteral(resourceName: "book8.jpg"),#imageLiteral(resourceName: "christmas1.jpg"),#imageLiteral(resourceName: "christmas2.jpg"),#imageLiteral(resourceName: "christmas3.jpg"),#imageLiteral(resourceName: "wedding1.jpg"),#imageLiteral(resourceName: "wedding2.jpg"),#imageLiteral(resourceName: "wedding3.jpg"),#imageLiteral(resourceName: "wedding4.jpg")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imagesCollectionView)
        imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        imagesCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imagesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        imagesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
    }
}

// MARK:  UICOllectionView delegate

extension InternalGalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onImageChosenFromGallery(images[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}

// MARK:  UICollectionView data source

extension InternalGalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image cell", for: indexPath) as? ImageCell ?? ImageCell()
        cell.setImage(image: images[indexPath.row])
        return cell
    }
    
}

protocol InternalGalleryViewControllerDelegate {
    func onImageChosenFromGallery(_ image: UIImage)
}
