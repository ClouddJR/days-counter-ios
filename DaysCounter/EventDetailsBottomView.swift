//
//  EventDetailsBottomView.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 21/11/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit

class EventDetailsBottomView: UIView {
    
    var delegate: EventDetailsBottomViewDelegate?
    
    func show() {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [.curveEaseIn],
            animations: {
                self.center.y -= self.bounds.height
        })
    }
    
    @objc func hide(){
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            animations: {
                self.center.y += self.bounds.height
        }, completion: { completed in
            self.removeFromSuperview()
        })
    }
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 24.0
        stackView.addArrangedSubview(notesStackView)
        stackView.addArrangedSubview(repetitionStackView)
        stackView.addArrangedSubview(reminderStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var notesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.addArrangedSubview(notesSectionTitleLabel)
        stackView.addArrangedSubview(notesLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var notesSectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Notes", comment: "")
        label.textColor = .white
        label.textAlignment = .left
        label.font = label.font.withSize(23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("No notes", comment: "")
        label.textColor = .white
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cancelIcon = #imageLiteral(resourceName: "ic_cancel")
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(cancelIcon, for: .normal)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var repetitionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.addArrangedSubview(repetitionSectionTitleLabel)
        stackView.addArrangedSubview(repetitionLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var repetitionSectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Repetition", comment: "")
        label.textColor = .white
        label.textAlignment = .left
        label.font = label.font.withSize(23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var repetitionLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Only once", comment: "")
        label.textColor = .white
        label.textAlignment = .justified
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var reminderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.addArrangedSubview(reminderSectionTitleLabel)
        stackView.addArrangedSubview(reminderLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var reminderSectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Reminder", comment: "")
        label.textColor = .white
        label.textAlignment = .left
        label.font = label.font.withSize(23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var reminderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .justified
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var reminderMessageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.addArrangedSubview(reminderMessageSectionTitleLabel)
        stackView.addArrangedSubview(reminderMessageLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var reminderMessageSectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Reminder message", comment: "")
        label.textColor = .white
        label.textAlignment = .left
        label.font = label.font.withSize(23)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var reminderMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .justified
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 45/255, alpha: 0.9)
        layer.cornerRadius = 15
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        addSubview(mainStackView)
        addSubview(cancelButton)
    }
    
    private func addConstraints() {
        mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        
        cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        cancelButton.topAnchor.constraint(equalTo: notesSectionTitleLabel.topAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        cancelButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc private func dismissView() {
        hide()
    }
    
    func fillViewsWithDataFrom(event: Event) {
        notesLabel.text = event.notes == "" ? NSLocalizedString("None", comment: "") : event.notes
        
        let repetition = EventRepetition(rawValue: event.repetition)!
        switch repetition {
        case .once: repetitionLabel.text = NSLocalizedString("Only once", comment: "")
        case .daily: repetitionLabel.text = NSLocalizedString("Daily", comment: "")
        case .weekly: repetitionLabel.text = NSLocalizedString("Weekly", comment: "")
        case .monthly: repetitionLabel.text = NSLocalizedString("Monthly", comment: "")
        case .yearly: repetitionLabel.text = NSLocalizedString("Yearly", comment: "")
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        if let reminderDate = event.reminderDate {
            reminderLabel.text = formatter.string(from: reminderDate)
            mainStackView.addArrangedSubview(reminderMessageStackView)
            reminderMessageStackView.isHidden = false
            reminderMessageLabel.text = event.reminderMessage
        } else {
            reminderLabel.text = NSLocalizedString("None", comment: "")
            mainStackView.removeArrangedSubview(reminderMessageStackView)
            reminderMessageStackView.isHidden = true
        }
    }

}

protocol EventDetailsBottomViewDelegate {
    func onViewRemoveFromSuperView()
}
