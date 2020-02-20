//
//  EventsTabBarController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 24/12/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit
import FirebaseUI

class EventsTabBarController: UITabBarController, FUIAuthDelegate {
    
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
            case .Future:
                self?.viewControllers?.sort(by: { (viewController1, viewController2) -> Bool in
                    return String(describing: viewController1) < String(describing: viewController2)
                })
            case .Past:
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
        
        guard let authUI = FUIAuth.defaultAuthUI() else {
            return
        }
        
        authUI.delegate = self
        let emailAuth = FUIEmailAuth(authAuthUI: authUI,
                                     signInMethod: EmailPasswordAuthSignInMethod,
                                     forceSameDevice: false,
                                     allowNewEmailAccounts: true,
                                     requireDisplayName: false,
                                     actionCodeSetting: ActionCodeSettings())
        let providers: [FUIAuthProvider] = [
            emailAuth,
            FUIGoogleAuth(),
            FUIOAuth.appleAuthProvider()
        ]
        authUI.providers = providers
        
        let authVC = authUI.authViewController()
        authVC.modalPresentationStyle = .fullScreen
        present(authVC, animated: true, completion: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error, let errCode = FUIAuthErrorCode(rawValue: UInt(error._code)) {
            if errCode != .userCancelledSignIn {
                displayAlert(withLoginError: error.localizedDescription)
            }
        }
        
        if authDataResult != nil {
            databaseRepository.addLocalEventsToCloud()
        }
    }
    
    private func displayAlreadyLoggedInAlert(currentEmail: String?) {
        let message = NSLocalizedString("You are already logged in and your events are being synchronized", comment: "")
        let account = NSLocalizedString("Account: ", comment: "")
        let alertMessage = currentEmail == nil ? message : message + ".\n\n" + account + currentEmail!
        
        let alert = UIAlertController(title: NSLocalizedString("Information", comment: ""), message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Sign out", comment: ""), style: .destructive, handler: { (_) in
            self.userRepository.signOut()
        }))
        self.present(alert, animated: true)
    }
    
    private func displayAlert(withLoginError: String) {
        let alert = UIAlertController(title: NSLocalizedString("Login failed", comment: ""), message: withLoginError, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return LoginViewController(authUI: authUI)
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        
        return false
    }
}
