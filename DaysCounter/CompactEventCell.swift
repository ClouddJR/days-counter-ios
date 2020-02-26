//
//  CompactEventCell.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 26/02/2020.
//  Copyright © 2020 CloudDroid. All rights reserved.
//

import UIKit

class CompactEventCell: EventCell {
    
    private lazy var cellBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var eventImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var eventImageDim: UIView = {
        let view = UIView(frame: CGRect(origin: bounds.origin, size: bounds.size))
        view.layer.backgroundColor = UIColor.black.cgColor
        view.layer.opacity = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Constants.dateStackViewSpacing
        stackView.addArrangedSubview(yearStackView)
        stackView.addArrangedSubview(monthStackView)
        stackView.addArrangedSubview(weekStackView)
        stackView.addArrangedSubview(dayStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var yearStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(yearNumberLabel)
        stackView.addArrangedSubview(yearTitleLabel)
        return stackView
    }()
    
    private lazy var yearNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.dateStackViewNumber)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var yearTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = label.font.withSize(Constants.dateStackViewTitle)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var monthStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(monthNumberLabel)
        stackView.addArrangedSubview(monthTitleLabel)
        return stackView
    }()
    
    private lazy var monthNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.dateStackViewNumber)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var monthTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = label.font.withSize(Constants.dateStackViewTitle)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var weekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(weekNumberLabel)
        stackView.addArrangedSubview(weekTitleLabel)
        return stackView
    }()
    
    private lazy var weekNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.dateStackViewNumber)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var weekTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = label.font.withSize(Constants.dateStackViewTitle)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var dayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(dayNumberLabel)
        stackView.addArrangedSubview(dayTitleLabel)
        return stackView
    }()
    
    private lazy var dayNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.dateStackViewNumber)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var dayTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = label.font.withSize(Constants.dateStackViewTitle)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.titleLabelSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.dateLabelSize, weight: .ultraLight)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    
    private func setupView() {
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(cellBackground)
        contentView.addSubview(eventImage)
        contentView.addSubview(eventImageDim)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(dateStackView)
    }
    
    private func setConstraints() {
        backgroundColor = .clear
        
        cellBackground.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        cellBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3).isActive = true
        cellBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        
        eventImage.topAnchor.constraint(equalTo: cellBackground.topAnchor, constant: 2).isActive = true
        eventImage.bottomAnchor.constraint(equalTo: cellBackground.bottomAnchor, constant: -2).isActive = true
        eventImage.leadingAnchor.constraint(equalTo: cellBackground.leadingAnchor, constant: 3).isActive = true
        eventImage.widthAnchor.constraint(equalToConstant: 76).isActive = true
        eventImage.layer.cornerRadius = 10
        
        eventImageDim.topAnchor.constraint(equalTo: cellBackground.topAnchor, constant: 2).isActive = true
        eventImageDim.bottomAnchor.constraint(equalTo: cellBackground.bottomAnchor, constant: -2).isActive = true
        eventImageDim.leadingAnchor.constraint(equalTo: cellBackground.leadingAnchor, constant: 3).isActive = true
        eventImageDim.layer.cornerRadius = 10
        
        dateLabel.bottomAnchor.constraint(equalTo: cellBackground.bottomAnchor, constant: -18).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: eventImage.trailingAnchor, constant: 10).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: eventImage.topAnchor, constant: 18).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: eventImage.trailingAnchor, constant: 10).isActive = true
        let constr = titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateStackView.leadingAnchor, constant: -15)
        constr.isActive = true
        
        dateStackView.topAnchor.constraint(equalTo: cellBackground.topAnchor, constant: 5).isActive = true
        dateStackView.bottomAnchor.constraint(equalTo: cellBackground.bottomAnchor, constant: -5).isActive = true
        dateStackView.trailingAnchor.constraint(equalTo: cellBackground.trailingAnchor, constant: -8).isActive = true
    }
    
    override func updateCellView(with event: Event) {
        titleLabel.text = event.name
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = !event.isEntireDay ? .short : .none
        let eventDate = EventOperator.getDate(from: event)
        dateLabel.text = formatter.string(from: eventDate)
        eventImage.image = EventOperator.getImage(from: event)
        eventImageDim.layer.opacity = event.imageDim

        
        titleLabel.font = UIFont(name: event.fontType, size: titleLabel.font.pointSize)
        dateLabel.font = UIFont(name: event.fontType, size: dateLabel.font.pointSize)
        yearNumberLabel.font = UIFont(name: event.fontType, size: yearNumberLabel.font.pointSize)
        yearTitleLabel.font = UIFont(name: event.fontType, size: yearTitleLabel.font.pointSize)
        monthNumberLabel.font = UIFont(name: event.fontType, size: monthNumberLabel.font.pointSize)
        monthTitleLabel.font = UIFont(name: event.fontType, size: monthTitleLabel.font.pointSize)
        weekNumberLabel.font = UIFont(name: event.fontType, size: weekNumberLabel.font.pointSize)
        weekTitleLabel.font = UIFont(name: event.fontType, size: weekTitleLabel.font.pointSize)
        dayNumberLabel.font = UIFont(name: event.fontType, size: dayNumberLabel.font.pointSize)
        dayTitleLabel.font = UIFont(name: event.fontType, size: dayTitleLabel.font.pointSize)
        
        let calculatedComponents = DateCalculator.calculateDate(eventDate: eventDate, areYearsIncluded: event.areYearsIncluded, areMonthsIncluded: event.areMonthsIncluded, areWeekIncluded: event.areWeeksIncluded, areDaysIncluded: event.areDaysIncluded, isTimeIncluded: false)
        
        if let years = calculatedComponents.years {
            yearTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Years title", comment: ""), years)
            yearNumberLabel.text = String(years)
        }
        
        if let months = calculatedComponents.months {
            monthTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Months title", comment: ""), months)
            monthNumberLabel.text = String(months)
        }
        
        if let weeks = calculatedComponents.weeks {
            weekTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Weeks title", comment: ""), weeks)
            weekNumberLabel.text = String(weeks)
        }
        
        if let days = calculatedComponents.days {
            dayTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Days title", comment: ""), days)
            dayNumberLabel.text = String(days)
        }
        
        yearStackView.removeFromSuperview()
        monthStackView.removeFromSuperview()
        weekStackView.removeFromSuperview()
        dayStackView.removeFromSuperview()
        
        if event.areYearsIncluded {dateStackView.addArrangedSubview(yearStackView)}
        if event.areMonthsIncluded {dateStackView.addArrangedSubview(monthStackView)}
        if event.areWeeksIncluded {dateStackView.addArrangedSubview(weekStackView)}
        if event.areDaysIncluded {dateStackView.addArrangedSubview(dayStackView)}
    }
    
    private func removeSubviewsConstraints() {
        cellBackground.removeFromSuperview()
        eventImage.removeFromSuperview()
        eventImageDim.removeFromSuperview()
        titleLabel.removeFromSuperview()
        dateLabel.removeFromSuperview()
        dateStackView.removeFromSuperview()
    }
}

extension CompactEventCell {
    
    struct Constants {
        static let titleLabelSize: CGFloat = 16
        static let dateLabelSize: CGFloat = 13
        static let dateStackViewSpacing: CGFloat = 12
        static let dateStackViewNumber: CGFloat = 18
        static let dateStackViewTitle: CGFloat = 12
    }
}
