//
//  EventBackgroundViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 18/09/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit
import RealmSwift

class EventBackgroundViewController: UIViewController {
    
    // MARK:  IBOutlets and custom views
    
    @IBOutlet var yearsSectionStackView: UIStackView!
    @IBOutlet var yearsNumberLabel: UILabel!
    @IBOutlet var yearsTitleLabel: UILabel!
    
    @IBOutlet var monthsSectionStackView: UIStackView!
    @IBOutlet var monthsNumberLabel: UILabel!
    @IBOutlet var monthsTitleLabel: UILabel!
    
    @IBOutlet var weeksSectionStackView: UIStackView!
    @IBOutlet var weeksNumberLabel: UILabel!
    @IBOutlet var weeksTitleLabel: UILabel!
    
    @IBOutlet var daysSectionStackView: UIStackView!
    @IBOutlet var daysNumberLabel: UILabel!
    @IBOutlet var daysTitleLabel: UILabel!
    
    @IBOutlet var hoursSectionStackView: UIStackView!
    @IBOutlet var hoursNumberLabel: UILabel!
    @IBOutlet var hoursTitleLabel: UILabel!
    
    @IBOutlet var minutesSectionStackView: UIStackView!
    @IBOutlet var minutesTitleLabel: UILabel!
    @IBOutlet var minutesNumberLabel: UILabel!
    
    @IBOutlet var secondsSectionStackView: UIStackView!
    @IBOutlet var secondsNumberLabel: UILabel!
    @IBOutlet var secondsTitleLabel: UILabel!
    
    @IBOutlet var eventTitleLabel: UILabel!
    @IBOutlet var eventDateLabel: UILabel!
    
    @IBOutlet weak var changeBackgroundButton: UIButton!
    @IBOutlet weak var customizeButton: UIButton!
    
    @IBAction func addEvent(_ sender: Any) {
        prepareEvent()
        EventOperator.setImageAndSaveLocally(image: eventImageView.image!, for: event)
        databaseRepository.addEvent(event)
        scheduleNotificationIfSet()
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBOutlet weak var backgroundImageView: UIImageView! {
        didSet {
            let _ = backgroundImageView.addBlurEffect(withStyle: .dark)
        }
    }
    
    @IBOutlet weak var eventImageView: UIImageView! {
        didSet {
            eventImageView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private lazy var eventImageViewDim: UIView = {
        let view = UIView(frame: CGRect(origin: eventImageView.bounds.origin, size: eventImageView.bounds.size))
        view.layer.backgroundColor = UIColor.black.cgColor
        view.layer.opacity = 0.0
        return view
    }()
    
    @IBOutlet weak var imageRatioConstraint: NSLayoutConstraint!
    
    private lazy var dimView: UIView = {
        let view = UIView(frame: CGRect(origin: self.view.frame.origin, size: self.view.frame.size))
        view.layer.backgroundColor = UIColor.black.cgColor
        view.layer.opacity = 0.4
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = Constants.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = Constants.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var customizeView : EventCustomizeView = {
        let view = EventCustomizeView()
        view.delegate = self
        return view
    }()
    
    // MARK:  variables
    private let databaseRepository = DatabaseRepository()
    
    var isInEditMode = false
    
    var event = Event()
    
    private var previousNavBarTintColor: UIColor?
    private var previousTextAttributes: [NSAttributedString.Key : Any]?
    
    private var shouldYearsSectionBeVisible = false
    private var shouldMonthsSectionBeVisible = false
    private var shouldWeeksSectionBeVisible = false
    private var shouldDaysSectionBeVisible = true
    private var shouldTimeSectionBeVisible = false
    
    private var dateTimer: Timer?
    
    // MARK:  lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        styleNavigationBar()
        updateUIWithPassedEventData()
        calculateDate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialImage()
        setInitialFont()
        setEventImageAspectRatio()
        setInitialEventPictureDim()
        updateLabelsFontSizes(
            withSectionNumberFont: daysNumberLabel.font.withSize(eventImageView.frame.height * Constants.sectionNumberSizeMultiplier),
            withSectionTitleFont: daysTitleLabel.font.withSize(eventImageView.frame.height * Constants.sectionTitleSizeMultiplier),
            withEventTitleFont: eventTitleLabel.font.withSize(eventImageView.frame.height * Constants.eventTitleSizeMultiplier),
            withEventDateFont: eventDateLabel.font.withSize(eventImageView.frame.height * Constants.eventDateSizeMultiplier)
        )
        updateUIIfInEditMode()
        addMainCounterStackViews()
        addButtonClickActions()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        restorePreviousNavigationBarTitleColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        restorePreviousNavigationBarStyle()
        dateTimer?.invalidate()
    }
    
    // MARK:  helper methods
    
    private func styleNavigationBar() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        previousNavBarTintColor = navigationController?.navigationBar.tintColor
        navigationController?.navigationBar.tintColor = .white
        
        if previousTextAttributes != nil {
            previousTextAttributes = navigationController?.navigationBar.titleTextAttributes
        }
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func updateUIWithPassedEventData() {
        eventTitleLabel.text = event.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = !event.isEntireDay ? .short : .none
        eventDateLabel.text = dateFormatter.string(from: EventOperator.getDate(from: event))
    }
    
    private func setInitialImage() {
        let image = UIImage(named: "nature4.jpg")
        eventImageView.image = image
        backgroundImageView.image = image
    }
    
    private func setInitialFont() {
        if !isInEditMode {
            event.fontType = "Helvetica"
        }
    }
    
    private func setEventImageAspectRatio() {
        let ratio = view.frame.height / view.frame.width
        imageRatioConstraint.isActive = false
        
        NSLayoutConstraint(item: eventImageView!, attribute: .height, relatedBy: .equal, toItem: eventImageView, attribute: .width, multiplier: ratio, constant: 0).isActive = true
        
        eventImageView.layoutIfNeeded()
    }
    
    private func setInitialEventPictureDim() {
        eventImageView.addSubview(eventImageViewDim)
    }
    
    private func updateLabelsFontSizes(withSectionNumberFont sectionNumberFont: UIFont, withSectionTitleFont sectionTitleFont: UIFont, withEventTitleFont eventTitleFont: UIFont, withEventDateFont eventDateFont: UIFont) {
        
        yearsNumberLabel.font = sectionNumberFont
        yearsTitleLabel.font = sectionTitleFont
        monthsNumberLabel.font = sectionNumberFont
        monthsTitleLabel.font = sectionTitleFont
        weeksNumberLabel.font = sectionNumberFont
        weeksTitleLabel.font = sectionTitleFont
        daysNumberLabel.font = sectionNumberFont
        daysTitleLabel.font = sectionTitleFont
        
        hoursNumberLabel.font = sectionNumberFont
        hoursTitleLabel.font = sectionTitleFont
        minutesNumberLabel.font = sectionNumberFont
        minutesTitleLabel.font = sectionTitleFont
        secondsNumberLabel.font = sectionNumberFont
        secondsTitleLabel.font = sectionTitleFont
        
        eventTitleLabel.font = eventTitleFont
        eventDateLabel.font = eventDateFont
    }
    
    private func updateUIIfInEditMode() {
        if isInEditMode {
            let image = EventOperator.getImage(from: event)
            backgroundImageView.image = image
            eventImageView.image = image
            
            shouldYearsSectionBeVisible = event.areYearsIncluded
            shouldMonthsSectionBeVisible = event.areMonthsIncluded
            shouldWeeksSectionBeVisible = event.areWeeksIncluded
            shouldDaysSectionBeVisible = event.areDaysIncluded
            shouldTimeSectionBeVisible = event.isTimeIncluded
            
            updateLabelsColor(with: EventOperator.getFontColor(from: event)!)
            
            let sectionNumberFont = UIFont(name: event.fontType, size: daysNumberLabel.font.pointSize)
            let sectionTitleFont = UIFont(name: event.fontType, size: daysTitleLabel.font.pointSize)
            let eventTitleFont = UIFont(name: event.fontType, size: eventTitleLabel.font.pointSize)
            let eventDateFont = UIFont(name: event.fontType, size: eventDateLabel.font.pointSize)
            
            updateLabelsFontSizes(
                withSectionNumberFont: sectionNumberFont!,
                withSectionTitleFont: sectionTitleFont!,
                withEventTitleFont: eventTitleFont!,
                withEventDateFont: eventDateFont!
            )
            
            eventImageViewDim.layer.opacity = event.imageDim
            
            customizeView.fontTypeLabel.text = event.fontType
            customizeView.formatYearsSwitch.isOn = event.areYearsIncluded
            customizeView.formatMonthsSwitch.isOn = event.areMonthsIncluded
            customizeView.formatWeeksSwitch.isOn = event.areWeeksIncluded
            customizeView.formatDaysSwitch.isOn = event.areDaysIncluded
            customizeView.formatTimeSwitch.isOn = event.isTimeIncluded
            
            customizeView.fontColorCircleView.subviews[0].backgroundColor = EventOperator.getFontColor(from: event)
            customizeView.pictureDimSlider.value = event.imageDim
        }
    }
    
    private func addMainCounterStackViews() {
        view.addSubview(dateStackView)
        view.addSubview(timeStackView)
        removeCounterStackViewsFromSuperview()
        conditionallyAddCounterStackViews()
        updateMainStackViewsConstraints()
    }
    
    private func removeCounterStackViewsFromSuperview() {
        yearsSectionStackView?.removeFromSuperview()
        monthsSectionStackView?.removeFromSuperview()
        weeksSectionStackView?.removeFromSuperview()
        daysSectionStackView?.removeFromSuperview()
        hoursSectionStackView?.removeFromSuperview()
        minutesSectionStackView?.removeFromSuperview()
        secondsSectionStackView?.removeFromSuperview()
    }
    
    private func conditionallyAddCounterStackViews() {
        if (shouldYearsSectionBeVisible) {dateStackView.addArrangedSubview(yearsSectionStackView)}
        if (shouldMonthsSectionBeVisible) {dateStackView.addArrangedSubview(monthsSectionStackView)}
        if (shouldWeeksSectionBeVisible) {dateStackView.addArrangedSubview(weeksSectionStackView)}
        if (shouldDaysSectionBeVisible) {dateStackView.addArrangedSubview(daysSectionStackView)}
        
        if (shouldTimeSectionBeVisible) {
            timeStackView.addArrangedSubview(hoursSectionStackView)
            timeStackView.addArrangedSubview(minutesSectionStackView)
            timeStackView.addArrangedSubview(secondsSectionStackView)
        }
    }
    
    private func updateMainStackViewsConstraints() {
        dateStackView.layoutIfNeeded()
        dateStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dateStackView.centerYAnchor.constraint(equalTo: eventImageView.centerYAnchor, constant: getDateStackViewYMargin(dateStackView)).isActive = true
        
        NSLayoutConstraint(item: dateStackView, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: eventImageView, attribute: .leading, multiplier: 1, constant: Constants.stackViewEdgeMargin).isActive = true
        
        NSLayoutConstraint(item: dateStackView, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: eventImageView, attribute: .trailing, multiplier: 1, constant: Constants.stackViewEdgeMargin).isActive = true
        
        timeStackView.layoutIfNeeded()
        timeStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timeStackView.centerYAnchor.constraint(equalTo: eventImageView.centerYAnchor, constant: getTimeStackViewYMargin(timeStackView)).isActive = true
        
        NSLayoutConstraint(item: timeStackView, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: eventImageView, attribute: .leading, multiplier: 1, constant: Constants.stackViewEdgeMargin).isActive = true
        
        NSLayoutConstraint(item: timeStackView, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: eventImageView, attribute: .trailing, multiplier: 1, constant: Constants.stackViewEdgeMargin).isActive = true
    }
    
    private func addButtonClickActions() {
        changeBackgroundButton.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        customizeButton.addTarget(self, action: #selector(showCustomizeView), for: .touchUpInside)
    }
    
    @objc private func showImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.changeBackgroundButton
            popoverController.sourceRect = CGRect(x: self.changeBackgroundButton.bounds.midX, y: 0, width: 0, height: 0)
            popoverController.permittedArrowDirections = [.down]
        }
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Pre-installed images", comment: ""), style: .default, handler: { (action) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "internalGalleryViewController") as! InternalGalleryViewController
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("From the Internet", comment: ""), style: .default, handler: { (action) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "internetGalleryViewController") as! InternetGalleryViewController
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Photo library", comment: ""), style: .default, handler: { (action) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action) in}))
        
        self.present(actionSheet, animated: true)
    }
    
    @objc private func showCustomizeView() {
        addDimView()
        view.addSubview(customizeView)
        customizeView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20).isActive = true
        customizeView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20).isActive = true
        customizeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        customizeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        customizeView.layoutIfNeeded()
        customizeView.show()
    }
    
    private func addDimView() {
        view.addSubview(dimView)
    }
    
    private func calculateDate() {
        //stop the previous timer
        dateTimer?.invalidate()
        
        if shouldTimeSectionBeVisible {
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
                                                      areYearsIncluded: shouldYearsSectionBeVisible,
                                                      areMonthsIncluded: shouldMonthsSectionBeVisible,
                                                      areWeekIncluded: shouldWeeksSectionBeVisible,
                                                      areDaysIncluded: shouldDaysSectionBeVisible,
                                                      isTimeIncluded: shouldTimeSectionBeVisible)
        if let years = components.years {
            yearsTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Years title", comment: ""), years)
            yearsNumberLabel.text = String(years)
        }
        
        if let months = components.months {
            monthsTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Months title", comment: ""), months)
            monthsNumberLabel.text = String(months)
        }
        
        if let weeks = components.weeks {
            weeksTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Weeks title", comment: ""), weeks)
            weeksNumberLabel.text = String(weeks)
        }
        
        if let days = components.days {
            daysTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Days title", comment: ""), days)
            daysNumberLabel.text = String(days)
        }
        
        if let hours = components.hours {
            hoursTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Hours title", comment: ""), hours)
            hoursNumberLabel.text = String(hours)
        }
        
        if let minutes = components.minutes {
            minutesTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Minutes title", comment: ""), minutes)
            minutesNumberLabel.text = String(minutes)
        }
        
        if let seconds = components.seconds {
            secondsTitleLabel.text = String.localizedStringWithFormat(NSLocalizedString("Seconds title", comment: ""), seconds)
            secondsNumberLabel.text = String(seconds)
        }
        
    }
    
    private func removeDimView() {
        dimView.removeFromSuperview()
    }
    
    private func restorePreviousNavigationBarTitleColor() {
        navigationController?.navigationBar.titleTextAttributes = previousTextAttributes
    }
    
    private func restorePreviousNavigationBarStyle() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = nil
        navigationController?.navigationBar.barStyle = .default
    }
    
    private func prepareEvent() {
        event.areYearsIncluded = shouldYearsSectionBeVisible
        event.areMonthsIncluded = shouldMonthsSectionBeVisible
        event.areWeeksIncluded = shouldWeeksSectionBeVisible
        event.areDaysIncluded = shouldDaysSectionBeVisible
        event.isTimeIncluded = shouldTimeSectionBeVisible
    }
    
    private func scheduleNotificationIfSet() {
        if let reminderDate = event.reminderDate {
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = event.name!
            content.body = event.reminderMessage
            content.sound = .default
            
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
            
            let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: event.id!, content: content, trigger: trigger)
            center.removePendingNotificationRequests(withIdentifiers: [event.id!])
            center.add(request)
        }
    }
    
    private func updateLabelsColor(with color: UIColor) {
        yearsNumberLabel.textColor = color
        yearsTitleLabel.textColor = color
        monthsNumberLabel.textColor = color
        monthsTitleLabel.textColor = color
        weeksNumberLabel.textColor = color
        weeksTitleLabel.textColor = color
        daysNumberLabel.textColor = color
        daysTitleLabel.textColor = color
        hoursNumberLabel.textColor = color
        hoursTitleLabel.textColor = color
        minutesNumberLabel.textColor = color
        minutesTitleLabel.textColor = color
        secondsNumberLabel.textColor = color
        secondsTitleLabel.textColor = color
        eventTitleLabel.textColor = color
        eventDateLabel.textColor = color
    }
}

// MARK:  Touch events

extension EventBackgroundViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let touchedView = touch?.view {
            if touchedView != customizeView && !getAllSubviews(fromView: customizeView).contains(touchedView) {
                customizeView.hide()
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

// MARK:  EventCustomizeView delegate

extension EventBackgroundViewController: EventCustomizeViewDelegate {
    
    func onSliderValueChanged(_ value: Float) {
        eventImageViewDim.layer.opacity = value
        event.imageDim = value
    }
    
    func onSliderTouchedDown() {
        dimView.isHidden = true
    }
    
    func onSliderTouchedUp() {
        dimView.isHidden = false
    }
    
    func onViewRemovedFromSuperview() {
        removeDimView()
    }
    
    func onFontTypeChanged(_ fontName: String) {
        let sectionNumberFont = UIFont(name: fontName, size: daysNumberLabel.font.pointSize)
        let sectionTitleFont = UIFont(name: fontName, size: daysTitleLabel.font.pointSize)
        let eventTitleFont = UIFont(name: fontName, size: eventTitleLabel.font.pointSize)
        let eventDateFont = UIFont(name: fontName, size: eventDateLabel.font.pointSize)
        
        updateLabelsFontSizes(
            withSectionNumberFont: sectionNumberFont!,
            withSectionTitleFont: sectionTitleFont!,
            withEventTitleFont: eventTitleFont!,
            withEventDateFont: eventDateFont!
        )
        
        event.fontType = fontName
    }
    
    func onFontColorChanged(_ color: UIColor) {
        updateLabelsColor(with: color)
        EventOperator.updateFontColor(with: color, for: event)
    }
    
    func onSwitchValueChanged(
        _ areYearsIncluded: Bool,
        _ areMonthsIncluded: Bool,
        _ areWeeksIncluded: Bool,
        _ areDaysIncluded: Bool,
        _ isTimeIncluded: Bool) {
        shouldYearsSectionBeVisible = areYearsIncluded
        shouldMonthsSectionBeVisible = areMonthsIncluded
        shouldWeeksSectionBeVisible = areWeeksIncluded
        shouldDaysSectionBeVisible = areDaysIncluded
        shouldTimeSectionBeVisible = isTimeIncluded
        
        dateStackView.removeFromSuperview()
        timeStackView.removeFromSuperview()
        addMainCounterStackViews()
        view.bringSubviewToFront(dimView)
        view.bringSubviewToFront(customizeView)
        
        calculateDate()
    }
}

// MARK:  UIImagePickerController delegate

extension EventBackgroundViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "imageCropViewController") as! ImageCropViewController
        vc.image = info[.originalImage] as? UIImage
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK:  ImageCropViewController delegate

extension EventBackgroundViewController: ImageCropViewControllerDelegate {
    
    func onImageCropped(_ image: UIImage) {
        backgroundImageView.image = image
        eventImageView.image = image
    }
}

// MARK:  InternalGalleryViewController delegate

extension EventBackgroundViewController: InternalGalleryViewControllerDelegate {
    
    func onImageChosenFromGallery(_ image: UIImage) {
        backgroundImageView.image = image
        eventImageView.image = image
    }
}

// MARK:  InternetGalleryViewController delegate

extension EventBackgroundViewController: InternetGalleryViewControllerDelegate {
    
    func onImageChosenFromTheInternet(_ image: UIImage) {
        backgroundImageView.image = image
        eventImageView.image = image
    }
}

// MARK:  view constants

extension EventBackgroundViewController {
    
    struct Constants {
        static let sectionNumberSizeMultiplier: CGFloat = 0.055
        static let sectionTitleSizeMultiplier: CGFloat = 0.019
        static let eventTitleSizeMultiplier: CGFloat = 0.028
        static let eventDateSizeMultiplier: CGFloat = 0.018
        static let stackViewSpacing: CGFloat = 16.0
        static let stackViewEdgeMargin: CGFloat = 10.0
    }
    
    func getDateStackViewYMargin(_ dateStackView: UIStackView) -> CGFloat {
        return -(dateStackView.bounds.height / 2 + (shouldTimeSectionBeVisible ? 15 : 5))
    }
    
    func getTimeStackViewYMargin(_ timeStackView: UIStackView) -> CGFloat {
        return (timeStackView.bounds.height / 2 + 10)
    }
}
