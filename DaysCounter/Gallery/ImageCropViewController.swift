import UIKit

protocol ImageCropViewControllerDelegate {
    func onImageCropped(_ image: UIImage)
}

final class ImageCropViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.maximumZoomScale = 4.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var delegate: ImageCropViewControllerDelegate?
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyStyling()
        addSubviews()
        addConstraints()
        displayImage()
    }
    
    private func applyStyling() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        
        navigationItem.title = NSLocalizedString("Reposition the image", comment: "")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .cancel, primaryAction: UIAction() { _ in
            self.navigationController?.popViewController(animated: true)
        })
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done, primaryAction: UIAction() { _ in
            self.saveImageAndDismiss()
        })
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func addSubviews() {
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
    }
    
    private func addConstraints() {
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    }
    
    private func displayImage() {
        imageView.image = image
        
        // Change minimum zoom scale so that the image always fill the entire screen
        scrollView.minimumZoomScale = max(UIScreen.main.bounds.height / image!.size.height, UIScreen.main.bounds.width / image!.size.width)
        scrollView.zoomScale = scrollView.minimumZoomScale
        view.layoutIfNeeded()
        
        // Scroll to the center of the image
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width / 2 - UIScreen.main.bounds.width / 2, y: 0)
    }
    
    private func saveImageAndDismiss() {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        delegate?.onImageCropped(image)
        navigationController?.popViewController(animated: true)
    }
}

extension ImageCropViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
