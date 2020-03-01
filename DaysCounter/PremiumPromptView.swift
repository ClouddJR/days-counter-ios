//
//  PremiumPromptView.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 01/03/2020.
//  Copyright © 2020 CloudDroid. All rights reserved.
//

import UIKit

class PremiumPromptView: UIView {
    
    var delegate: PremiumPromptViewDelegate?
    
    private let crownImage = #imageLiteral(resourceName: "ic_crown")
    
    lazy var crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = crownImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var premiumLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("This feature is only available for premium users", comment: "")
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("More info", comment: ""), for: .normal)
        button.tintColor = UIColor(red: 242/255, green: 132/255, blue: 91/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func animateEnter(){
        center.y += bounds.height
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.5,
            options: [.curveEaseIn],
            animations: {
                self.center.y -= self.bounds.height
        })
    }
    
    private func setupView() {
        clipsToBounds = true
        backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1.0)
        layer.cornerRadius = 20
        addSubviews()
    }
    
    private func addSubviews() {
        addSubview(crownImageView)
        addSubview(premiumLabel)
        addSubview(moreInfoButton)
        
        crownImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        crownImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        crownImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        crownImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        premiumLabel.topAnchor.constraint(equalTo: crownImageView.bottomAnchor, constant: 15).isActive = true
        premiumLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        premiumLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        
        moreInfoButton.topAnchor.constraint(equalTo: premiumLabel.bottomAnchor, constant: 15).isActive = true
        moreInfoButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        moreInfoButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        moreInfoButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        moreInfoButton.addTarget(self, action: #selector(showPremiumViewController), for: .touchUpInside)
    }
    
    @objc private func showPremiumViewController() {
        delegate?.moreInfoButtonClicked()
    }
}

protocol PremiumPromptViewDelegate {
    func moreInfoButtonClicked()
}
