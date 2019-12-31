//
//  ImageCropViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 30/09/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit

class ImageCropViewController: UIViewController {
    
    // IBOutlets and IBActions
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.maximumZoomScale = 4.0
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func saveImageAndClose(_ sender: Any) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        delegate?.onImageCropped(image)
        navigationController?.popViewController(animated: true)
    }
    
    // variables
    
    var delegate: ImageCropViewControllerDelegate?
    
    var image: UIImage?
    
    // lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        styleNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayImage()
    }
    
    // helper methods
    
    private func styleNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.tintColor = .white
        
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func displayImage() {
        imageView.image = image
        
        //change minimum zoom scale so the that image always fill the entire screen
        scrollView.minimumZoomScale = max(UIScreen.main.bounds.height / image!.size.height, UIScreen.main.bounds.width / image!.size.width)
        scrollView.zoomScale = scrollView.minimumZoomScale
        view.layoutIfNeeded()
        
        //scroll to the center of the image
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width / 2 - UIScreen.main.bounds.width / 2, y: 0)
    }
}

// MARK:  ScrollView delegate

extension ImageCropViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

protocol ImageCropViewControllerDelegate {
    func onImageCropped(_ image: UIImage)
}
