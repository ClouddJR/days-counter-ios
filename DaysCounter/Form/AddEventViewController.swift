import UIKit

final class AddEventViewController: UITableViewController {
    @IBOutlet weak var eventNameLabel: UITextField!
    @IBOutlet weak var entireDaySwitch: UISwitch!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    
    @IBOutlet weak var eventRepetitionLabel: UILabel!
    @IBOutlet weak var eventNotesTextView: UITextView!
    
    @IBOutlet weak var reminderSwitchCell: UITableViewCell!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var reminderDateAndTimeCell: UITableViewCell!
    @IBOutlet weak var reminderDateAndTimePicker: UIDatePicker!
    @IBOutlet weak var reminderMessageCell: UITableViewCell!
    @IBOutlet weak var reminderMessageTextView: UITextView!
    
    @IBAction func dismiss(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func entireDaySwitchValueChanged(_ sender: UISwitch) {
        eventDatePicker.datePickerMode = sender.isOn ? .date : .dateAndTime
    }
    
    @IBAction func reminderSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            askForNotificationsPermission()
        }
        reminderDateAndTimeCell.isHidden = !sender.isOn
        reminderMessageCell.isHidden = !sender.isOn
        reminderSwitchCell.separatorInset = UIEdgeInsets(top: 0, left: sender.isOn ? 20 : 0, bottom: 0, right: 0)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func goToEventBackgroundVC(_ sender: Any) {
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
    
    private let reminderDateAndTimeCellIndexPath = IndexPath(row: 1, section: 2)
    private let reminderDateAndTimePickerIndexPath = IndexPath(row: 2, section: 2)
    
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
    
    private func displayAlertAboutRequiredFields() {
        let alert = UIAlertController(title: NSLocalizedString("Name And Date Fields Are Required", comment: ""), message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    private func prepareEvent() {
        event.name = eventNameLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        event.date = eventDatePicker.date // Check if changing time is needed here as before
        event.isEntireDay = entireDaySwitch.isOn
        event.repetition = eventRepetition.rawValue
        event.notes = eventNotesTextView.text == NSLocalizedString("Notes", comment: "") ? "" : eventNotesTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if reminderSwitch.isOn {
            event.reminderDate = reminderDateAndTimePicker.date
            event.reminderMessage = reminderMessageTextView.text == NSLocalizedString("Reminder message", comment: "") ? "" :reminderMessageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            event.reminderDate = nil
        }
    }
    
    private func setUpTextViews() {
        eventNotesTextView.delegate = self
        eventNotesTextView.text = NSLocalizedString("Notes", comment: "")
        eventNotesTextView.textColor = UIColor.placeholderText
        eventNotesTextView.textContainer.lineFragmentPadding = 0
        eventNotesTextView.textContainerInset = .zero
        eventNotesTextView.backgroundColor = .clear
        
        reminderMessageTextView.delegate = self
        reminderMessageTextView.text = NSLocalizedString("Reminder message", comment: "")
        reminderMessageTextView.textColor = UIColor.placeholderText
        reminderMessageTextView.textContainer.lineFragmentPadding = 0
        reminderMessageTextView.textContainerInset = .zero
        reminderMessageTextView.backgroundColor = .clear
    }
    
    private func updateUIIfInEditMode() {
        if isInEditMode {
            eventNameLabel.text = event.name
            eventDatePicker.date = event.date!
            entireDaySwitch.isOn = event.isEntireDay
            
            if event.reminderDate != nil {
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

extension AddEventViewController: RepetitionTableViewControllerDelegate {
    func updateRepetition(with indexPath: IndexPath) {
        eventRepetition = EventRepetition(rawValue: indexPath.row)!
    }
}

extension AddEventViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = textView.tag == 0 ? NSLocalizedString("Notes", comment: "") : NSLocalizedString("Reminder message", comment: "")
            textView.textColor = UIColor.placeholderText
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor.placeholderText && !text.isEmpty {
            textView.textColor = UIColor.label
            textView.text = text
        } else {
            return true
        }
        
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.placeholderText {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
}

extension AddEventViewController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}
