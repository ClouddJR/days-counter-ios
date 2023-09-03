import UIKit

final class ImageCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        clipsToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
    func setImage(image: UIImage) {
        imageView.isHidden = false
        activityIndicator.isHidden = true
        
        imageView.image = image
    }
    
    func clearImage() {
        imageView.isHidden = true
        activityIndicator.isHidden = false
        
        activityIndicator.startAnimating()
        
        imageView.image = nil
    }
}
