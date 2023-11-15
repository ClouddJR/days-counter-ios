import Foundation
import SwiftUI

final class LoginHostingController: UIHostingController<LoginView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction() { _ in
            self.navigationController?.dismiss(animated: true)
        })
    }
}
