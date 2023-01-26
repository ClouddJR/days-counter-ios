import UIKit

class LoadingButton: UIButton {
    
    var originalText: String?
    var originalInsets: UIEdgeInsets?
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return activityIndicator
    }()
    
    func toggleLoading(_ isLoading: Bool) {
        if isLoading {
            isEnabled = false
            originalText = titleLabel?.text
            originalInsets = self.contentEdgeInsets
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            setTitle("", for: .normal)
            activityIndicator.startAnimating()
        } else {
            isEnabled = true
            self.contentEdgeInsets = originalInsets ?? self.contentEdgeInsets
            setTitle(originalText, for: .normal)
            activityIndicator.stopAnimating()
        }
    }

}
