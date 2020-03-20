//
//  AuthPickerViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 18/02/2020.
//  Copyright © 2020 CloudDroid. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: FUIAuthPickerViewController {
    
    private var firstAppereance = true
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Welcome", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        let text = NSLocalizedString("Login gives you the possibility of synchronizing your events with the cloud so that they are accessible on all of your devices.", comment: "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.hyphenationFactor = 10
        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.attributedText = attributedString
        return label
    }()
    
    private lazy var privacyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = label.font.withSize(12)
        label.numberOfLines = 0
        let text = NSLocalizedString("If you choose to log in, nothing besides your events data will be stored on our servers. You can ask for a complete data deletion by contacting us via our email.\nYou can find our email and privacy policy on the settings page.", comment: "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.hyphenationFactor = 10
        let attributedString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        label.attributedText = attributedString
        return label
    }()
    
    private lazy var premiumDimView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.black.cgColor
        view.layer.opacity = 0.5
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var premiumPromptView: PremiumPromptView = {
        let view = PremiumPromptView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = NSLocalizedString("Login", comment: "")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        (view.subviews[0] as! UIScrollView).contentSize = contentView.bounds.size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMainView()
        setUpPremiumPrompt()
        firstAppereance = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.premiumPromptView.alpha = 1.0
            self.premiumDimView.alpha = 0.5
        }
        if firstAppereance {
            premiumPromptView.animateEnter()
        }
        firstAppereance = false
    }
    
    private func setUpMainView() {
        let scrollView = view.subviews[0] as! UIScrollView
        let buttonsView = scrollView.subviews[0]
        buttonsView.removeFromSuperview()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        
        contentView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        
        contentView.addSubview(welcomeLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(buttonsView)
        contentView.addSubview(privacyLabel)
        
        welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
        buttonsView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40).isActive = true
        buttonsView.heightAnchor.constraint(equalToConstant: 280).isActive = true
        buttonsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        buttonsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        privacyLabel.topAnchor.constraint(equalTo: buttonsView.bottomAnchor).isActive = true
        privacyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        privacyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        privacyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
    }
    
    private func setUpPremiumPrompt() {
        if !Defaults.isPremiumUser() {
            let scrollView = view.subviews[0] as! UIScrollView
            scrollView.isUserInteractionEnabled = false
            
            view.addSubview(premiumDimView)
            premiumDimView.alpha = 0.0
            premiumDimView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            premiumDimView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            premiumDimView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            premiumDimView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            view.addSubview(premiumPromptView)
            premiumPromptView.alpha = 0.0
            premiumPromptView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            premiumPromptView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            premiumPromptView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20).isActive = true
        }
    }
}

extension LoginViewController: PremiumPromptViewDelegate {
    
    func moreInfoButtonClicked() {
        showPremiumScreen()
    }
    
    private func showPremiumScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "premiumNavigationController") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
