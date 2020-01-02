//
//  TodayViewController.swift
//  WidgetPastEvents
//
//  Created by Arkadiusz Chmura on 31/12/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var realm: Realm!
    var pastEvents: Results<Event>!
    
    let rowHeight = 50
    
    private lazy var eventsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width, height: 50)
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(EventCell.self, forCellWithReuseIdentifier: "event cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initRealm()
        sortEvents()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        view.addSubview(eventsCollectionView)
        eventsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        eventsCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        eventsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        eventsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        eventsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        let height = maxSize.height >= CGFloat(pastEvents.count * rowHeight) ? CGFloat(pastEvents.count * rowHeight) : maxSize.height
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: height) : maxSize
    }
    
    private func initRealm() {
        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.clouddroid.dayscounter")!
        let realmPath = directory.appendingPathComponent("db.realm")
        
        var config = Realm.Configuration()
        config.fileURL = realmPath
        
        realm = try! Realm(configuration: config)
        pastEvents = realm.objects(Event.self).filter(NSPredicate(format: "date < %@", NSDate()))
    }
    
    private func sortEvents() {
        let sortingOrder = Defaults.getSortingOrder()
        switch sortingOrder {
        case .DaysAscending: pastEvents = pastEvents.sorted(byKeyPath: "date", ascending: false)
        case .DaysDescending: pastEvents = pastEvents.sorted(byKeyPath: "date", ascending: true)
        case .TimeAdded: pastEvents = pastEvents.sorted(byKeyPath: "id", ascending: true)
        }
    }
    
}

extension TodayViewController: UICollectionViewDelegate {
    
}

extension TodayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pastEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "event cell", for: indexPath) as? EventCell ?? EventCell()
        return cell
    }
}


class EventCell: UICollectionViewCell {
    
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
        label.text = "10"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: Constants.dateStackViewNumber)
        return label
    }()
    
    private lazy var yearTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "years"
        label.textColor = .white
        label.font = label.font.withSize(Constants.dateStackViewTitle)
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
        label.text = "2"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: Constants.dateStackViewNumber)
        return label
    }()
    
    private lazy var monthTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "months"
        label.textColor = .white
        label.font = label.font.withSize(Constants.dateStackViewTitle)
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
        label.text = "7"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: Constants.dateStackViewNumber)
        return label
    }()
    
    private lazy var weekTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "weeks"
        label.textColor = .white
        label.font = label.font.withSize(Constants.dateStackViewTitle)
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
        label.text = "4"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: Constants.dateStackViewNumber)
        return label
    }()
    
    private lazy var dayTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "days"
        label.textColor = .white
        label.font = label.font.withSize(Constants.dateStackViewTitle)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.titleLabelSize, weight: .black)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.dateLabelSize, weight: .ultraLight)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    
    private func setupView() {
        backgroundColor = .blue
        //addSubviews()
        //setConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(eventImage)
        contentView.addSubview(eventImageDim)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(dateStackView)
    }
    
    private func setConstraints() {
        eventImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        eventImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        eventImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        eventImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        eventImage.layer.cornerRadius = 10
        
        eventImageDim.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        eventImageDim.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        eventImageDim.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        eventImageDim.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        eventImageDim.layer.cornerRadius = 10
        
        dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: eventImage.leadingAnchor, constant: 10).isActive = true
        
        titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -6).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: eventImage.leadingAnchor, constant: 10).isActive = true
        
        dateStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14).isActive = true
        dateStackView.trailingAnchor.constraint(equalTo: eventImage.trailingAnchor, constant: -14).isActive = true
    }
    
    func updateCellView(with event: Event) {
        titleLabel.text = event.name
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = event.time != nil ? .short : .none
        let eventDate = EventOperator.getDate(from: event)
        dateLabel.text = formatter.string(from: eventDate)
        eventImage.image = EventOperator.getImage(from: event)
        eventImageDim.layer.opacity = event.imageDim
        
        titleLabel.textColor = EventOperator.getFontColor(from: event)
        dateLabel.textColor = EventOperator.getFontColor(from: event)
        yearNumberLabel.textColor = EventOperator.getFontColor(from: event)
        yearTitleLabel.textColor = EventOperator.getFontColor(from: event)
        monthNumberLabel.textColor = EventOperator.getFontColor(from: event)
        monthTitleLabel.textColor = EventOperator.getFontColor(from: event)
        weekNumberLabel.textColor = EventOperator.getFontColor(from: event)
        weekTitleLabel.textColor = EventOperator.getFontColor(from: event)
        dayNumberLabel.textColor = EventOperator.getFontColor(from: event)
        dayTitleLabel.textColor = EventOperator.getFontColor(from: event)
        
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
            yearNumberLabel.text = String(years)
        }
        
        if let months = calculatedComponents.months {
            monthNumberLabel.text = String(months)
        }
        
        if let weeks = calculatedComponents.weeks {
            weekNumberLabel.text = String(weeks)
        }
        
        if let days = calculatedComponents.days {
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
}

extension EventCell {
    
    struct Constants {
        static let titleLabelSize: CGFloat = 10
        static let dateLabelSize: CGFloat = 8
        static let dateStackViewSpacing: CGFloat = 10
        static let dateStackViewNumber: CGFloat = 15
        static let dateStackViewTitle: CGFloat = 10
    }
}

