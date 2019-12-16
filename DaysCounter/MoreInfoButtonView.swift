//
//  MoreInfoButtonView.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 12/11/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit

class MoreInfoButtonView: UIView {
    
    var delegate: MoreInfoButtonViewDelegate?
    
    private lazy var circleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.addArrangedSubview(firstCircle)
        stackView.addArrangedSubview(secondCircle)
        stackView.addArrangedSubview(thirdCircle)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var firstCircle: UIView = {
        let contentView = UIView()
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: circleRadius, height: circleRadius))
        circleView.layer.cornerRadius = circleView.frame.height / 2
        circleView.backgroundColor = .white
        contentView.addSubview(circleView)
        return contentView
    }()
    
    lazy var secondCircle: UIView = {
        let contentView = UIView()
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: circleRadius, height: circleRadius))
        circleView.layer.cornerRadius = circleView.frame.height / 2
        circleView.backgroundColor = .white
        contentView.addSubview(circleView)
        return contentView
    }()
    
    lazy var thirdCircle: UIView = {
        let contentView = UIView()
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: circleRadius, height: circleRadius))
        circleView.layer.cornerRadius = circleView.frame.height / 2
        circleView.backgroundColor = .white
        contentView.addSubview(circleView)
        return contentView
    }()
    
    var circleRadius: CGFloat = 7 {
        didSet {
            updateCircleRadius()
        }
    }
    
    private func updateCircleRadius() {
        firstCircle.subviews[0].frame = CGRect(x: 0, y: 0, width: circleRadius, height: circleRadius)
        secondCircle.subviews[0].frame = CGRect(x: 0, y: 0, width: circleRadius, height: circleRadius)
        thirdCircle.subviews[0].frame = CGRect(x: 0, y: 0, width: circleRadius, height: circleRadius)
        firstCircle.subviews[0].layer.cornerRadius = circleRadius / 2
        secondCircle.subviews[0].layer.cornerRadius = circleRadius / 2
        thirdCircle.subviews[0].layer.cornerRadius = circleRadius / 2
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(circleStackView)
        circleStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        circleStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        circleStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        circleStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateCircleRadiusColor(UIColor.gray)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateCircleRadiusColor(UIColor.white)
        delegate?.onButtonClick()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateCircleRadiusColor(UIColor.white)
    }
    
    private func updateCircleRadiusColor(_ color: UIColor) {
        firstCircle.subviews[0].backgroundColor = color
        secondCircle.subviews[0].backgroundColor = color
        thirdCircle.subviews[0].backgroundColor = color
        layoutIfNeeded()
    }
}

protocol MoreInfoButtonViewDelegate {
    func onButtonClick()
}
