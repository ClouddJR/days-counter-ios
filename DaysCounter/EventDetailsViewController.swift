//
//  EventDetailsViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 22/10/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit
import RealmSwift

class EventDetailsViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var imageViewDim: UIView = {
        let view = UIView(frame: CGRect(origin: imageView.bounds.origin, size: imageView.bounds.size))
        view.layer.backgroundColor = UIColor.black.cgColor
        view.layer.opacity = 0.0
        return view
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 20.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var yearsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.contentMode = .scaleToFill
        stackView.spacing = 0
        stackView.addArrangedSubview(yearNumberLabel)
        stackView.addArrangedSubview(yearTitleLabel)
        return stackView
    }()
    
    private lazy var yearNumberLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(45)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var yearTitleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(21)
        label.text = "years"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var monthsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.contentMode = .scaleToFill
        stackView.spacing = 0
        stackView.addArrangedSubview(monthNumberLabel)
        stackView.addArrangedSubview(monthTitleLabel)
        return stackView
    }()
    
    private lazy var monthNumberLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(45)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var monthTitleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(21)
        label.text = "months"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weeksStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.contentMode = .scaleToFill
        stackView.spacing = 0
        stackView.addArrangedSubview(weekNumberLabel)
        stackView.addArrangedSubview(weekTitleLabel)
        return stackView
    }()
    
    private lazy var weekNumberLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(45)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weekTitleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(21)
        label.text = "weeks"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var daysStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.contentMode = .scaleToFill
        stackView.spacing = 0
        stackView.addArrangedSubview(dayNumberLabel)
        stackView.addArrangedSubview(dayTitleLabel)
        return stackView
    }()
    
    private lazy var dayNumberLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(45)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dayTitleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(21)
        label.text = "days"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 20.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var hoursStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.contentMode = .scaleToFill
        stackView.spacing = 0
        stackView.addArrangedSubview(hourNumberLabel)
        stackView.addArrangedSubview(hourTitleLabel)
        return stackView
    }()
    
    private lazy var hourNumberLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(45)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hourTitleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(21)
        label.text = "hours"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var minutesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.contentMode = .scaleToFill
        stackView.spacing = 0
        stackView.addArrangedSubview(minuteNumberLabel)
        stackView.addArrangedSubview(minuteTitleLabel)
        return stackView
    }()
    
    private lazy var minuteNumberLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(45)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var minuteTitleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(21)
        label.text = "minutes"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var secondsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.contentMode = .scaleToFill
        stackView.spacing = 0
        stackView.addArrangedSubview(secondNumberLabel)
        stackView.addArrangedSubview(secondTitleLabel)
        return stackView
    }()
    
    private lazy var secondNumberLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(45)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var secondTitleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(21)
        label.text = "seconds"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = label.font.withSize(25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 19, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var moreInfoButtonView: MoreInfoButtonView = {
        let view = MoreInfoButtonView()
        view.delegate = self
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var moreInfoView: EventDetailsBottomView = {
        let view = EventDetailsBottomView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let realm = try! Realm()
    
    var eventId: String = ""
    private var event: Event!
    
    private var dateTimer: Timer?
    
    private var previousNavBarTintColor: UIColor?
    
    @IBAction func editEvent(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "addEventNavigationController") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        if let addVc = vc.children.first as? AddEventViewController {
            addVc.event = Event(value: event!)
            addVc.isInEditMode = true
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    @IBAction func deleteEvent(_ sender: UIBarButtonItem) {
        displayAlertAndDeleteIfConfirmed()
    }
    
    private func displayAlertAndDeleteIfConfirmed() {
        let alert = UIAlertController(title: "Are you sure you want to delete this event?", message: "This operation cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            self.deleteLocalImage(at: URL(string: self.event.localImagePath)!)
            self.realm.beginWrite()
            self.realm.delete(self.event)
            try! self.realm.commitWrite()
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    private func deleteLocalImage(at path: URL) {
        do {
            try FileManager.default.removeItem(at: path)
        } catch {
            print("Could not delete file: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        styleNavigationBar()
        calculateDate()
    }
    
    private func styleNavigationBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        previousNavBarTintColor = navigationController?.navigationBar.tintColor
        navigationController?.navigationBar.tintColor = .white
        
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEventFromDB()
        addSubviews()
        addConstraints()
        setImage()
        addImageDim()
        setDateAndTitle()
        changeFontType()
        changeFontColor()
        calculateDate()
        addMainCounterStackViews()
        updateDetailsView()
        listenForDataChanges()
    }
    
    private func getEventFromDB() {
        event = try! Realm().objects(Event.self).filter(NSPredicate(format: "id = %@", eventId)).first
    }
    
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(moreInfoButtonView)
    }
    
    private func addConstraints() {
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -10).isActive = true
        
        dateLabel.bottomAnchor.constraint(equalTo: moreInfoButtonView.topAnchor, constant: -30).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20).isActive = true
        
        moreInfoButtonView.widthAnchor.constraint(equalToConstant: 29).isActive = true
        moreInfoButtonView.heightAnchor.constraint(equalToConstant: 7).isActive = true
        moreInfoButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moreInfoButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -moreInfoButtonView.circleRadius - 25).isActive = true
    }
    
    private func setImage() {
        imageView.image = EventOperator.getImage(from: event)
        imageView.layoutIfNeeded()
    }
    
    private func addImageDim() {
        imageView.addSubview(imageViewDim)
        imageViewDim.layer.opacity = event.imageDim
    }
    
    private func setDateAndTitle() {
        titleLabel.text = event.name
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = event.time != nil ? .short : .none
        dateLabel.text = formatter.string(from: EventOperator.getDate(from: event))
    }
    
    private func changeFontType() {
        let sectionNumberFont = UIFont(name: event.fontType, size: Constants.sectionNumberFontSize)
        let sectionTitleFont = UIFont(name: event.fontType, size: Constants.sectionTitleFontSize)
        let titleFont = UIFont(name: event.fontType, size: Constants.eventTitleFontSize)
        let dateFont = UIFont(name: event.fontType, size: Constants.eventDateFontSize)
        
        yearNumberLabel.font = sectionNumberFont
        yearTitleLabel.font = sectionTitleFont
        monthNumberLabel.font = sectionNumberFont
        monthTitleLabel.font = sectionTitleFont
        weekNumberLabel.font = sectionNumberFont
        weekTitleLabel.font = sectionTitleFont
        dayNumberLabel.font = sectionNumberFont
        dayTitleLabel.font = sectionTitleFont
        
        hourNumberLabel.font = sectionNumberFont
        hourTitleLabel.font = sectionTitleFont
        minuteNumberLabel.font = sectionNumberFont
        minuteTitleLabel.font = sectionTitleFont
        secondNumberLabel.font = sectionNumberFont
        secondTitleLabel.font = sectionTitleFont
        
        titleLabel.font = titleFont
        dateLabel.font = dateFont
    }
    
    private func changeFontColor() {
        let color = EventOperator.getFontColor(from: event)
        yearNumberLabel.textColor = color
        yearTitleLabel.textColor = color
        monthNumberLabel.textColor = color
        monthTitleLabel.textColor = color
        weekNumberLabel.textColor = color
        weekTitleLabel.textColor = color
        dayNumberLabel.textColor = color
        dayTitleLabel.textColor = color
        hourNumberLabel.textColor = color
        hourTitleLabel.textColor = color
        minuteNumberLabel.textColor = color
        minuteTitleLabel.textColor = color
        secondNumberLabel.textColor = color
        secondTitleLabel.textColor = color
        
        titleLabel.textColor = color
        dateLabel.textColor = color
    }
    
    private func addMainCounterStackViews() {
        view.addSubview(dateStackView)
        view.addSubview(timeStackView)
        conditionallyAddCounterStackViews()
        updateMainStackViewsConstraints()
    }
    
    private func conditionallyAddCounterStackViews() {
        if (event.areYearsIncluded) {dateStackView.addArrangedSubview(yearsStackView)}
        if (event.areMonthsIncluded) {dateStackView.addArrangedSubview(monthsStackView)}
        if (event.areWeeksIncluded) {dateStackView.addArrangedSubview(weeksStackView)}
        if (event.areDaysIncluded) {dateStackView.addArrangedSubview(daysStackView)}
        
        if (event.isTimeIncluded) {
            timeStackView.addArrangedSubview(hoursStackView)
            timeStackView.addArrangedSubview(minutesStackView)
            timeStackView.addArrangedSubview(secondsStackView)
        }
    }
    
    private func updateMainStackViewsConstraints() {
        dateStackView.layoutIfNeeded()
        dateStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateStackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: getDateStackViewYMargin(dateStackView)).isActive = true
        dateStackView.leadingAnchor.constraint(greaterThanOrEqualTo: imageView.leadingAnchor, constant: 10).isActive = true
        dateStackView.trailingAnchor.constraint(lessThanOrEqualTo: imageView.trailingAnchor, constant: 10).isActive = true
        
        timeStackView.layoutIfNeeded()
        timeStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeStackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: getTimeStackViewYMargin(timeStackView)).isActive = true
        timeStackView.leadingAnchor.constraint(greaterThanOrEqualTo: imageView.leadingAnchor, constant: 10).isActive = true
        timeStackView.trailingAnchor.constraint(lessThanOrEqualTo: imageView.trailingAnchor, constant: 10).isActive = true
    }
    
    private func updateDetailsView() {
        moreInfoView.fillViewsWithDataFrom(event: event)
    }
    
    private func listenForDataChanges() {
        _ = event.observe { change in
            switch change {
            case .change( _):
                self.setImage()
                self.addImageDim()
                self.setDateAndTitle()
                self.changeFontType()
                self.changeFontColor()
                self.calculateDate()
                self.addMainCounterStackViews()
                self.updateDetailsView()
            case .error(_): break
            case .deleted: break
            }
        }
    }
    
    private func calculateDate() {
        //stop the previous timer
        dateTimer?.invalidate()
        
        if event.isTimeIncluded {
            calculateDateEverySecond()
        } else {
            calculateDateOnlyOnce()
        }
    }
    
    private func calculateDateEverySecond() {
        dateTimer = Timer(timeInterval: 1.0, target: self, selector: #selector(calculateDateAndUpdateLabels), userInfo: nil, repeats: true)
        dateTimer?.fire()
        RunLoop.main.add(dateTimer!, forMode: .common)
    }
    
    private func calculateDateOnlyOnce() {
        calculateDateAndUpdateLabels()
    }
    
    @objc private func calculateDateAndUpdateLabels() {
        print("calculating")
        let components = DateCalculator.calculateDate(eventDate: EventOperator.getDate(from: event), todayDate: Date(),
                                                      areYearsIncluded: event.areYearsIncluded,
                                                      areMonthsIncluded: event.areMonthsIncluded,
                                                      areWeekIncluded: event.areWeeksIncluded,
                                                      areDaysIncluded: event.areDaysIncluded,
                                                      isTimeIncluded: event.isTimeIncluded)
        if let years = components.years {
            yearNumberLabel.text = String(years)
        }
        
        if let months = components.months {
            monthNumberLabel.text = String(months)
        }
        
        if let weeks = components.weeks {
            weekNumberLabel.text = String(weeks)
        }
        
        if let days = components.days {
            dayNumberLabel.text = String(days)
        }
        
        if let hours = components.hours {
            hourNumberLabel.text = String(hours)
        }
        
        if let minutes = components.minutes {
            minuteNumberLabel.text = String(minutes)
        }
        
        if let seconds = components.seconds {
            secondNumberLabel.text = String(seconds)
        }
        
        view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restorePreviousNavigationBarStyle()
        dateTimer?.invalidate()
    }
    
    private func restorePreviousNavigationBarStyle() {
        navigationController?.navigationBar.tintColor = previousNavBarTintColor
        navigationController?.navigationBar.barStyle = .default
        
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func showMoreInfoView() {
        view.addSubview(moreInfoView)
        moreInfoView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 50).isActive = true
        moreInfoView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -50).isActive = true
        moreInfoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        moreInfoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moreInfoView.widthAnchor.constraint(greaterThanOrEqualToConstant: 250).isActive = true
        moreInfoView.layoutIfNeeded()
        moreInfoView.show()
    }
    
}

extension EventDetailsViewController {
    
    struct Constants {
        static let sectionNumberFontSize: CGFloat = 44
        static let sectionTitleFontSize: CGFloat = 15
        static let eventTitleFontSize: CGFloat = 23
        static let eventDateFontSize: CGFloat = 15
        static let stackViewSpacing: CGFloat = 16.0
        static let stackViewEdgeMargin: CGFloat = 10.0
    }
    
    func getDateStackViewYMargin(_ dateStackView: UIStackView) -> CGFloat {
        return -(dateStackView.bounds.height / 2 + (event.isTimeIncluded ? 20 : 5))
    }
    
    func getTimeStackViewYMargin(_ timeStackView: UIStackView) -> CGFloat {
        return (timeStackView.bounds.height / 2)
    }
}

extension EventDetailsViewController: MoreInfoButtonViewDelegate {
    func onButtonClick() {
        showMoreInfoView()
    }
}

extension EventDetailsViewController: EventDetailsBottomViewDelegate {
    func onViewRemoveFromSuperView() {
        // remove dim view
    }
}

// MARK:  Touch events

extension EventDetailsViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let touchedView = touch?.view {
            if touchedView != moreInfoView && !getAllSubviews(fromView: moreInfoView).contains(touchedView) {
                moreInfoView.hide()
            } else {
                super.touchesBegan(touches, with: event)
            }
        } else {
            super.touchesBegan(touches, with: event)
        }
    }
    
    private func getAllSubviews(fromView view: UIView) -> [UIView] {
        if view.subviews.count == 0 {
            return []
        } else {
            var subviewsList = [UIView]()
            for subview in view.subviews {
                subviewsList += [subview]
                subviewsList += getAllSubviews(fromView: subview)
            }
            return subviewsList
        }
    }
}

