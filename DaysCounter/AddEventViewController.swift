//
//  AddEventViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 13/09/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit

class AddEventViewController: UITableViewController {
    
    // MARK:  IBOutlets
    
    @IBOutlet weak var eventNameLabel: UITextField!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    @IBOutlet weak var entireDayCell: UITableViewCell!
    @IBOutlet weak var entireDaySwitch: UISwitch!
    @IBOutlet weak var eventTimeCell: UITableViewCell!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventTimePicker: UIDatePicker!
    
    @IBOutlet weak var eventRepetitionLabel: UILabel!
    @IBOutlet weak var eventNotesTextView: UITextView!
    
    @IBOutlet weak var reminderSwitchCell: UITableViewCell!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var reminderDateAndTimeCell: UITableViewCell!
    @IBOutlet weak var reminderDateAndTimeLabel: UILabel!
    @IBOutlet weak var reminderDateAndTimePicker: UIDatePicker!
    @IBOutlet weak var reminderMessageCell: UITableViewCell!
    @IBOutlet weak var reminderMessageTextView: UITextView!
    
    // MARK:  IBActions
    
    @IBAction func dismiss(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func entireDaySwitchValueChanged(_ sender: UISwitch) {
        eventTimeCell.isHidden = sender.isOn
        if sender.isOn {
            isEventTimePickerOpened = false
            updateConstraints(for: eventTimePicker, basedOn: self.isEventTimePickerOpened)
        } else {
            eventTimeCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        entireDayCell.separatorInset = UIEdgeInsets(top: 0, left: sender.isOn ? 0 : 20, bottom: 0, right: 0)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func reminderSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            askForNotificationsPermission()
        } else {
            isReminderDateAndTimePickerOpened = false
            updateConstraints(for: reminderDateAndTimePicker, basedOn: isReminderDateAndTimePickerOpened)
        }
        reminderDateAndTimeCell.isHidden = !sender.isOn
        reminderMessageCell.isHidden = !sender.isOn
        reminderSwitchCell.separatorInset = UIEdgeInsets(top: 0, left: sender.isOn ? 20 : 0, bottom: 0, right: 0)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func updateEventDateField(_ sender: UIDatePicker, forEvent event: UIEvent) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        updateDateLabel(for: eventDateLabel, with: eventDatePicker, at: IndexPath(row: 1, section: 0), using: dateFormatter)
    }
    
    @IBAction func updateEventTimeField(_ sender: UIDatePicker, forEvent event: UIEvent) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        updateDateLabel(for: eventTimeLabel, with: eventTimePicker, at: IndexPath(row: 4, section: 0), using: dateFormatter)
    }
    
    @IBAction func updateReminderDateAndTimeField(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        updateDateLabel(for: reminderDateAndTimeLabel, with: reminderDateAndTimePicker, at: IndexPath(row: 1, section: 2), using: dateFormatter)
    }
    
    @IBAction func goToEventBackgroundVC(_ sender: Any) {
        if isValidForm() {
            if let vc = lastSeguedToEventBackgroundVC {
                prepareEvent()
                vc.event.name = event.name
                vc.event.date = event.date
                vc.event.isEntireDay = event.isEntireDay
                vc.event.repetition = event.repetition
                vc.event.notes = event.notes
                vc.event.reminderDate = event.reminderDate
                vc.event.reminderMessage = event.reminderMessage
                vc.event.createdAt = event.createdAt
                navigationController?.pushViewController(vc, animated: true)
            } else {
                performSegue(withIdentifier: "eventBackgroundVCSegue", sender: sender)
            }
        }
        else {
            displayAlertAboutRequiredFields()
        }
    }
    
    
    // MARK:  variables
    
    var isInEditMode = false
    
    var event = Event()
    
    private var eventRepetition = EventRepetition(rawValue: 0)! {
        didSet {
            switch eventRepetition {
            case .once: eventRepetitionLabel.text = NSLocalizedString("Only once", comment: "")
            case .daily: eventRepetitionLabel.text = NSLocalizedString("Daily", comment: "")
            case .weekly: eventRepetitionLabel.text = NSLocalizedString("Weekly", comment: "")
            case .monthly: eventRepetitionLabel.text = NSLocalizedString("Monthly", comment: "")
            case .yearly: eventRepetitionLabel.text = NSLocalizedString("Yearly", comment: "")
            }
        }
    }
    
    private let eventDateCellIndexPath = IndexPath(row: 1, section: 0)
    private let eventDatePickerIndexPath = IndexPath(row: 2, section: 0)
    private let eventTimeCellIndexPath = IndexPath(row: 4, section: 0)
    private let eventTimePickerIndexPath = IndexPath(row: 5, section: 0)
    
    private let reminderDateAndTimeCellIndexPath = IndexPath(row: 1, section: 2)
    private let reminderDateAndTimePickerIndexPath = IndexPath(row: 2, section: 2)
    
    private var isEventDatePickerOpened = false
    private var isEventTimePickerOpened = false
    private var isReminderDateAndTimePickerOpened = false
    
    // MARK:  lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextViews()
        updateUIIfInEditMode()
        addTableViewGestureRecognizers()
        displayAlertInformingAboutNoPermission()
    }
    
    private var lastSeguedToEventBackgroundVC: EventBackgroundViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RepetitionTableViewController {
            vc.previousSelection = eventRepetition.rawValue
            vc.delegate = self
        }
        
        if let vc = segue.destination as? EventBackgroundViewController {
            prepareEvent()
            vc.event = event
            vc.isInEditMode = isInEditMode
            lastSeguedToEventBackgroundVC = vc
        }
    }
    
    private func isValidForm() -> Bool {
        return !isNameOrDateLabelEmpty()
    }
    
    private func isNameOrDateLabelEmpty() -> Bool {
        return eventNameLabel.text == "" || eventDateLabel.text == ""
    }
    
    private func displayAlertAboutRequiredFields() {
        let alert = UIAlertController(title: NSLocalizedString("Name And Date Fields Are Required", comment: ""), message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    private func prepareEvent() {
        event.name = eventNameLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        event.date = eventDateLabel.text != "" ? eventDatePicker.date : nil
        if !entireDaySwitch.isOn && eventTimeLabel.text != ""{
            let timeComponents = eventTimePicker.date.timeComponents()
            event.date = event.date!.with(hours: timeComponents.hour!, minutes: timeComponents.minute!)
            event.isEntireDay = false
        } else {
            event.date = event.date!.with(hours: 23, minutes: 59)
            event.isEntireDay = true
        }
        event.repetition = eventRepetition.rawValue
        event.notes = eventNotesTextView.text == NSLocalizedString("Notes", comment: "") ? "" : eventNotesTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if reminderSwitch.isOn {
            event.reminderDate = reminderDateAndTimeLabel.text != "" ? reminderDateAndTimePicker.date : nil
            event.reminderMessage = reminderMessageTextView.text == NSLocalizedString("Reminder message", comment: "") ? "" :reminderMessageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            event.reminderDate = nil
        }
    }
    
    // MARK:  helper methods
    
    private func setUpTextViews() {
        eventNotesTextView.delegate = self
        eventNotesTextView.text = NSLocalizedString("Notes", comment: "")
        eventNotesTextView.textColor = UIColor.lightGray
        eventNotesTextView.textContainer.lineFragmentPadding = 0
        eventNotesTextView.textContainerInset = .zero
        eventNotesTextView.backgroundColor = .clear
        
        reminderMessageTextView.delegate = self
        reminderMessageTextView.text = NSLocalizedString("Reminder message", comment: "")
        reminderMessageTextView.textColor = UIColor.lightGray
        reminderMessageTextView.textContainer.lineFragmentPadding = 0
        reminderMessageTextView.textContainerInset = .zero
        reminderMessageTextView.backgroundColor = .clear
    }
    
    private func updateUIIfInEditMode() {
        if isInEditMode {
            eventNameLabel.text = event.name
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            eventDateLabel.text = dateFormatter.string(from: event.date!)
            eventDatePicker.date = event.date!
            
            if !event.isEntireDay {
                let timeFormatter = DateFormatter()
                timeFormatter.timeStyle = .short
                eventTimeLabel.text = timeFormatter.string(from: event.date!)
                entireDaySwitch.isOn = false
                eventTimePicker.date = event.date!
                eventTimeCell.isHidden = false
                eventTimeCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                entireDayCell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
            if event.reminderDate != nil {
                let reminderDateFormatter = DateFormatter()
                reminderDateFormatter.dateStyle = .long
                reminderDateFormatter.timeStyle = .short
                reminderDateAndTimeLabel.text = reminderDateFormatter.string(from: event.reminderDate!)
                reminderDateAndTimePicker.date = event.reminderDate!
                if event.reminderMessage != "" {
                    reminderMessageTextView.text = event.reminderMessage
                    reminderMessageTextView.textColor = .label
                }
                reminderSwitch.isOn = true
                reminderDateAndTimeCell.isHidden = false
                reminderMessageCell.isHidden = false
                reminderSwitchCell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
            eventRepetition = EventRepetition(rawValue: event.repetition)!
            if event.notes != "" {
                eventNotesTextView.text = event.notes
                eventNotesTextView.textColor = .label
            }
        }
    }
    
    private func addTableViewGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGestureRecognizer)
        
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeUpGestureRecognizer.direction = .up
        swipeUpGestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(swipeUpGestureRecognizer)
        
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeDownGestureRecognizer.direction = .down
        swipeDownGestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(swipeDownGestureRecognizer)
    }
    
    private func displayAlertInformingAboutNoPermission() {
        guard isInEditMode && event.reminderDate != nil else {return}
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus != .authorized else {return}
            DispatchQueue.main.async {
                let alert = UIAlertController(title: NSLocalizedString("Notification Permission", comment: ""), message: NSLocalizedString("The app does not have a permission to use notifications so the reminder will be ignored. Please go to System settings to enable it.", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }
        }
    }
    
    private func updateDateLabel(for label: UILabel, with datePicker: UIDatePicker, at indexPath: IndexPath, using dateFormatter: DateFormatter) {
        let stringDate = dateFormatter.string(from: datePicker.date)
        label.text = stringDate
        UIView.performWithoutAnimation {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    private func updateConstraints(for picker: UIDatePicker, basedOn isOpened: Bool) {
        if !isOpened {
            picker.removeAllConstraints()
        } else {
            picker.removeAllConstraints()
            picker.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(
                item: picker,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: picker.superview,
                attribute: .centerX,
                multiplier: 1.0,
                constant: 0.0).isActive = true
            NSLayoutConstraint(
                item: picker,
                attribute: .top,
                relatedBy: .equal,
                toItem: picker.superview,
                attribute: .top,
                multiplier: 1.0,
                constant: 16.0).isActive = true
            let bottom = NSLayoutConstraint(
                item: picker,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: picker.superview,
                attribute: .bottom,
                multiplier: 1.0,
                constant: 16.0)
            bottom.priority = .init(999)
            bottom.isActive = true
        }
    }
    
    private func askForNotificationsPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { [weak self] granted, error in
            if granted {
                return
            } else {
                DispatchQueue.main.async {
                    self?.displayAlertAboutRequiredPermissionForReminders()
                    self?.reminderSwitch.isOn = false
                    self?.reminderDateAndTimeCell.isHidden = true
                    self?.reminderMessageCell.isHidden = true
                    self?.tableView.beginUpdates()
                    self?.tableView.endUpdates()
                }
            }
        }
    }
    
    private func displayAlertAboutRequiredPermissionForReminders() {
        let alert = UIAlertController(title: NSLocalizedString("Grant Permission", comment: ""), message: NSLocalizedString("In order to send reminders, the app needs to have a permission for that. Please go to System settings and enable it.", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        eventNotesTextView.resignFirstResponder()
        reminderMessageTextView.resignFirstResponder()
        eventNameLabel.resignFirstResponder()
    }
}

// MARK:  RepetitionTableViewController Delegate

extension AddEventViewController: RepetitionTableViewControllerDelegate {
    
    func updateRepetition(with indexPath: IndexPath) {
        eventRepetition = EventRepetition(rawValue: indexPath.row)!
    }
}

// MARK:  TableView delegate

extension AddEventViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == eventDatePickerIndexPath.section && indexPath.row == eventDatePickerIndexPath.row  {
            return self.isEventDatePickerOpened ? 216.0 : 0
        }
        
        if indexPath.section == eventTimePickerIndexPath.section && indexPath.row == eventTimePickerIndexPath.row {
            return self.isEventTimePickerOpened ? 216.0 : 0
        }
        
        if indexPath.section == reminderDateAndTimePickerIndexPath.section && indexPath.row == reminderDateAndTimePickerIndexPath.row {
            return self.isReminderDateAndTimePickerOpened ? 216.0 : 0
        }
        
        return shouldRowBeHidden(at: indexPath) ? 0.0 : super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    private func shouldRowBeHidden(at indexPath: IndexPath) -> Bool {
        return indexPath.section == eventTimeCellIndexPath.section && indexPath.row == eventTimeCellIndexPath.row && entireDaySwitch.isOn ||
            indexPath.section == reminderDateAndTimeCellIndexPath.section && indexPath.row == reminderDateAndTimeCellIndexPath.row && !reminderSwitch.isOn ||
            indexPath.section == reminderDateAndTimePickerIndexPath.section && indexPath.row == reminderDateAndTimePickerIndexPath.row && !reminderSwitch.isOn
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        
        if indexPath.section == eventDateCellIndexPath.section && indexPath.row == eventDateCellIndexPath.row {
            self.isEventDatePickerOpened = !self.isEventDatePickerOpened
            if self.isEventDatePickerOpened {
                isEventTimePickerOpened = false
                isReminderDateAndTimePickerOpened = false
            }
        }
        
        if indexPath.section == eventTimeCellIndexPath.section && indexPath.row == eventTimeCellIndexPath.row {
            self.isEventTimePickerOpened = !self.isEventTimePickerOpened
            if self.isEventTimePickerOpened {
                isEventDatePickerOpened = false
                isReminderDateAndTimePickerOpened = false
            }
        }
        
        var shouldScrollToBottom = false
        if indexPath.section == reminderDateAndTimeCellIndexPath.section && indexPath.row == reminderDateAndTimeCellIndexPath.row {
            self.isReminderDateAndTimePickerOpened = !self.isReminderDateAndTimePickerOpened
            if self.isReminderDateAndTimePickerOpened {
                isEventDatePickerOpened = false
                isEventTimePickerOpened = false
            } else {
                shouldScrollToBottom = true
            }
        }
        
        eventTimeCell.separatorInset = UIEdgeInsets(top: 0, left: self.isEventTimePickerOpened ? 20 : 0, bottom: 0, right: 0)
        
        updateConstraints(for: eventDatePicker, basedOn: self.isEventDatePickerOpened)
        updateConstraints(for: eventTimePicker, basedOn: self.isEventTimePickerOpened)
        updateConstraints(for: reminderDateAndTimePicker, basedOn: self.isReminderDateAndTimePickerOpened)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.endUpdates()
        
        if isReminderDateAndTimePickerOpened || shouldScrollToBottom {
            tableView.scrollToBottom(animated: true)
        }
    }
}

// MARK:  TextView delegate

extension AddEventViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = textView.tag == 0 ? NSLocalizedString("Notes", comment: "") : NSLocalizedString("Reminder message", comment: "")
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.label
            textView.text = text
        } else {
            return true
        }
        
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
}

// MARK:  ScrollView delegate

extension AddEventViewController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}
