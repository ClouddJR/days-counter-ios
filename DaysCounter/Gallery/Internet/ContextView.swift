import Foundation
import UIKit

final class ContextView: UIStackView {
    var iconName: String = "" {
        didSet {
            updateIconView()
        }
    }
    
    var title: String = "" {
        didSet {
            titleView.text = NSLocalizedString(title, comment: "")
        }
    }
    
    var subtitle: String = "" {
        didSet {
            subtitleView.text = NSLocalizedString(subtitle, comment: "")
        }
    }
    
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .secondaryLabel
        imageView.isAccessibilityElement = false
        return imageView
    }()
    
    private lazy var titleView: UILabel = {
        let title = UILabel()
        title.font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: .boldSystemFont(ofSize: 24))
        title.textAlignment = .center
        title.numberOfLines = 0
        title.adjustsFontForContentSizeCategory = true
        return title
    }()
    
    private lazy var subtitleView: UILabel = {
        let subtitle = UILabel()
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
        
        addArrangedSubview(iconView)
        addArrangedSubview(titleView)
        addArrangedSubview(subtitleView)
        
        setCustomSpacing(8, after: iconView)
    }
    
    private func updateIconView() {
        let font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: .systemFont(ofSize: 42))
        let config = UIImage.SymbolConfiguration(font: font)
            .applying(UIImage.SymbolConfiguration(weight: .semibold))
        
        iconView.image = UIImage(systemName: iconName, withConfiguration: config)
    }
}
