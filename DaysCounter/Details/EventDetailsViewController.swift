import UIKit
import RealmSwift

final class EventDetailsViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var imageViewDim: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.black.cgColor
        view.layer.opacity = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 25.0
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
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 25.0
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

    private lazy var moreInfoButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        let image = UIImage(systemName: "ellipsis", withConfiguration: configuration)
        button.setImage(image , for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showMoreInfoView), for: .touchUpInside)
        return button
    }()
    
    private lazy var moreInfoView: EventDetailsBottomView = {
        let view = EventDetailsBottomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let databaseRepository = DatabaseRepository()
    
    var eventId: String = ""
    private var event: Event!
    var notificationToken: NotificationToken?
    
    private var dateTimer: Timer?
    
    private var previousNavBarTintColor: UIColor?
    private var previousTextAttributes: [NSAttributedString.Key : Any]?
    
    private var compactConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var sharedConstraints: [NSLayoutConstraint] = []
    
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
    
    @IBAction func shareEvent(_ sender: UIBarButtonItem) {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        if let img = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            let activityViewController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [.addToReadingList, .airDrop, .openInIBooks]
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            displayAlertAboutScreenshotError()
        }
    }
    
    private func displayAlertAboutScreenshotError() {
        let alert = UIAlertController(title: NSLocalizedString("The Screenshot Could Not Be Taken", comment: ""), message: NSLocalizedString("There was an error while getting the screen image for sharing.", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @IBAction func deleteEvent(_ sender: UIBarButtonItem) {
        displayAlertAndDeleteIfConfirmed()
    }
    
    private func displayAlertAndDeleteIfConfirmed() {
        let alert = UIAlertController(title: NSLocalizedString("Are you sure you want to delete this event?", comment: ""), message: NSLocalizedString("This operation cannot be undone.", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { (action) in
            self.cancelNotification()
            self.databaseRepository.deleteEvent(event: self.event)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    private func cancelNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [event.id!])
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTraitsObservable()
        clipViewToBounds()
        getEventFromDB()
        addSubviews()
        addConstraints()
        updateUIBasedOnEventData()
        listenForDataChanges()
    }
    
    private func registerTraitsObservable() {
        registerForTraitChanges([UITraitVerticalSizeClass.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            if self.traitCollection.verticalSizeClass == .compact {
                NSLayoutConstraint.deactivate(self.regularConstraints)
                NSLayoutConstraint.activate(self.compactConstraints)
            } else {
                NSLayoutConstraint.deactivate(self.compactConstraints)
                NSLayoutConstraint.activate(self.regularConstraints)
            }
            self.view.layoutIfNeeded()
        })
    }
    
    private func clipViewToBounds() {
        view.clipsToBounds = true
    }
    
    private func getEventFromDB() {
        event = databaseRepository.getEvent(with: eventId)
    }
    
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(moreInfoButton)
    }
    
    private func addConstraints() {
        regularConstraints.append(contentsOf: [
            dateLabel.bottomAnchor.constraint(equalTo: moreInfoButton.topAnchor, constant: -30)
        ])
        
        compactConstraints.append(contentsOf: [
            dateLabel.bottomAnchor.constraint(equalTo: moreInfoButton.topAnchor, constant: -3)
        ])
        
        sharedConstraints.append(contentsOf: [
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -10),
            
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            moreInfoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            moreInfoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate(traitCollection.verticalSizeClass == .compact
            ? compactConstraints : regularConstraints )
        NSLayoutConstraint.activate(sharedConstraints)
    }
    
    private func updateUIBasedOnEventData() {
        setImage()
        addImageDim()
        setDateAndTitle()
        changeFontType()
        changeFontColor()
        calculateDate()
        addMainCounterStackViews()
        updateDetailsView()
    }
    
    private func setImage() {
        imageView.image = EventOperator.getImage(from: event)
        imageView.layoutIfNeeded()
    }
    
    private func addImageDim() {
        imageView.addSubview(imageViewDim)
        imageViewDim.layer.opacity = event.imageDim
        imageViewDim.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        imageViewDim.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        imageViewDim.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        imageViewDim.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
    }
    
    private func setDateAndTitle() {
        titleLabel.text = event.name
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = !event.isEntireDay ? .short : .none
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
        notificationToken = event.observe { change in
            switch change {
            case .change(_, _):
                self.removeStackViews()
                self.updateUIBasedOnEventData()
                self.bringMoreViewToFrontIfPresent()
            case .error(_): break
            case .deleted: break
            }
        }
    }
    
    private func removeStackViews() {
        self.dateStackView.removeFromSuperview()
        self.dateStackView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        self.timeStackView.removeFromSuperview()
        self.timeStackView.subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    private func bringMoreViewToFrontIfPresent() {
        if !self.moreInfoView.isHidden {
            self.view.bringSubviewToFront(self.moreInfoView)
        }
    }
    
    private func calculateDate() {
        // Stop the previous timer
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
        let components = DateCalculator.calculateDate(eventDate: EventOperator.getDate(from: event), todayDate: Date(),
                                                      areYearsIncluded: event.areYearsIncluded,
                                                      areMonthsIncluded: event.areMonthsIncluded,
                                                      areWeekIncluded: event.areWeeksIncluded,
                                                      areDaysIncluded: event.areDaysIncluded,
                                                      isTimeIncluded: event.isTimeIncluded)
        if let years = components.years {
            yearTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Years title", comment: ""), years)
            yearNumberLabel.text = String(years)
        }
        
        if let months = components.months {
            monthTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Months title", comment: ""), months)
            monthNumberLabel.text = String(months)
        }
        
        if let weeks = components.weeks {
            weekTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Weeks title", comment: ""), weeks)
            weekNumberLabel.text = String(weeks)
        }
        
        if let days = components.days {
            dayTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Days title", comment: ""), days)
            dayNumberLabel.text = String(days)
        }
        
        if let hours = components.hours {
            hourTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Hours title", comment: ""), hours)
            hourNumberLabel.text = String(hours)
        }
        
        if let minutes = components.minutes {
            minuteTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Minutes title", comment: ""), minutes)
            minuteNumberLabel.text = String(minutes)
        }
        
        if let seconds = components.seconds {
            secondTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Seconds title", comment: ""), seconds)
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
        
        let textAttributes = [NSAttributedString.Key.foregroundColor :
            traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
    }
    
    @objc private func showMoreInfoView() {
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
        static let stackViewSpacing: CGFloat = 20.0
        static let stackViewEdgeMargin: CGFloat = 10.0
    }
    
    func getDateStackViewYMargin(_ dateStackView: UIStackView) -> CGFloat {
        return -(dateStackView.bounds.height / 2 + (event.isTimeIncluded ? 20 : 5))
    }
    
    func getTimeStackViewYMargin(_ timeStackView: UIStackView) -> CGFloat {
        return (timeStackView.bounds.height / 2)
    }
}

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
