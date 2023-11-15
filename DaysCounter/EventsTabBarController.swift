import UIKit
import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebaseOAuthUI
import FirebaseGoogleAuthUI

final class EventsTabBarController: UITabBarController, LoginViewDelegate {
    
    private let userRepository = UserRepository()
    private let databaseRepository = DatabaseRepository()
    private var userDefaultsObserver: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerUserDefaultsObserver()
    }
    
    private func registerUserDefaultsObserver() {
        userDefaultsObserver = UserDefaults.standard.observe(\.user_defaults_default_section, options: [.initial, .new], changeHandler: { [weak self] (defaults, change) in
            
            let sectionOrder = Defaults.getDefaultSection()
            switch sectionOrder {
            case .future:
                self?.viewControllers?.sort(by: { (viewController1, viewController2) -> Bool in
                    return String(describing: viewController1) < String(describing: viewController2)
                })
            case .past:
                self?.viewControllers?.sort(by: { (viewController1, viewController2) -> Bool in
                    return String(describing: viewController1) > String(describing: viewController2)
                })
            }
            self?.selectedIndex = 0
        })
    }
    
    deinit {
        userDefaultsObserver?.invalidate()
        userDefaultsObserver = nil
    }
    
    @IBAction func login(_ sender: UIBarButtonItem) {
        if userRepository.isUserLoggedIn() {
            displayAlreadyLoggedInAlert(currentEmail: userRepository.getUserEmail())
            return
        }
        
        let viewController = LoginHostingController(rootView: LoginView(delegate: self))
        let navigationController = UINavigationController(rootViewController: viewController)
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(navigationController, animated: true, completion: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error, let errCode = FUIAuthErrorCode(rawValue: UInt(error._code)) {
            if errCode != .userCancelledSignIn {
                displayAlert(withLoginError: error.localizedDescription)
            }
        }
        
        if authDataResult != nil {
            navigationController?.presentedViewController?.dismiss(animated: true)
            databaseRepository.addLocalEventsToCloud()
        }
    }
    
    private func displayAlreadyLoggedInAlert(currentEmail: String?) {
        let message = NSLocalizedString("Your events are being synchronized", comment: "")
        let account = NSLocalizedString("Account: ", comment: "")
        let alertMessage = currentEmail == nil ? message : message + ".\n\n" + account + currentEmail!
        
        let alert = UIAlertController(title: NSLocalizedString("You Are Already Logged In", comment: ""), message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Sign out", comment: ""), style: .destructive, handler: { (_) in
            self.userRepository.signOut()
        }))
        self.present(alert, animated: true)
    }
    
    private func displayAlert(withLoginError: String) {
        let alert = UIAlertController(title: NSLocalizedString("Login Failed", comment: ""), message: withLoginError, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
}
