import Foundation
import UIKit

final class NoImagesView: UIStackView {
    private lazy var icon: UIImageView = {
        let font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: .systemFont(ofSize: 42))
        let config = UIImage.SymbolConfiguration(font: font)
            .applying(UIImage.SymbolConfiguration(weight: .semibold))
        
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass", withConfiguration: config))
        imageView.tintColor = .secondaryLabel
        imageView.isAccessibilityElement = false
        
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.text = NSLocalizedString("No Images", comment: "")
        title.font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: .boldSystemFont(ofSize: 24))
        title.numberOfLines = 0
        title.adjustsFontForContentSizeCategory = true
        return title
    }()
    
    private lazy var subtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.text = NSLocalizedString("Check the spelling or try a new search.", comment: "")
        subtitle.font = UIFont.preferredFont(forTextStyle: .body)
        subtitle.textColor = UIColor.secondaryLabel
        subtitle.textAlignment = .center
        subtitle.numberOfLines = 0
        subtitle.adjustsFontForContentSizeCategory = true
        return subtitle
    }()
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        axis = .vertical
        alignment = .center
        spacing = 4
        
        addArrangedSubview(icon)
        addArrangedSubview(title)
        addArrangedSubview(subtitle)
        
        setCustomSpacing(8, after: icon)
    }
}
