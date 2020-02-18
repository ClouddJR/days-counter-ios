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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Logowanie"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        (view.subviews[0] as! UIScrollView).contentSize = contentView.bounds.size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        buttonsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}
