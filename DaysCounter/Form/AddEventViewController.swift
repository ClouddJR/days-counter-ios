import UIKit

final class AddEventViewController: UITableViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var entireDaySwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var repetitionLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var reminderSwitchCell: UITableViewCell!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var reminderMessageTextView: UITextView!
    
    var event = Event()
    
    var isInEditMode = false
    
    private var isReminderSectionHidden = true
    
    private var eventRepetition = EventRepetition(rawValue: 0)! {
        didSet {
            repetitionLabel.text = switch eventRepetition {
            case .once: NSLocalizedString("Only once", comment: "")
            case .daily: NSLocalizedString("Daily", comment: "")
            case .weekly: NSLocalizedString("Weekly", comment: "")
            case .monthly: NSLocalizedString("Monthly", comment: "")
            case .yearly: NSLocalizedString("Yearly", comment: "")
            }
        }
    }
    
    private var lastSeguedToEventBackgroundVC: EventBackgroundViewController?

    @IBAction func dismiss(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func entireDaySwitchValueChanged(_ sender: UISwitch) {
        datePicker.datePickerMode = sender.isOn ? .date : .dateAndTime
    }
    
    @IBAction func reminderSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            askForNotificationsPermission()
        }
        isReminderSectionHidden = !sender.isOn
        reminderSwitchCell.separatorInset = UIEdgeInsets(top: 0, left: sender.isOn ? 20 : 0, bottom: 0, right: 0)
        tableView.reloadData()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextViews()
        updateUIIfInEditMode()
        addTableViewGestureRecognizers()
        displayAlertInformingAboutNoPermission()
    }
    
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
        event.name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        event.date = datePicker.date // Check if changing time is needed here as before
        event.isEntireDay = entireDaySwitch.isOn
        event.repetition = eventRepetition.rawValue
        event.notes = notesTextView.text == NSLocalizedString("Notes", comment: "") ? "" : notesTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if reminderSwitch.isOn {
            event.reminderDate = reminderDatePicker.date
            event.reminderMessage = reminderMessageTextView.text == NSLocalizedString("Reminder message", comment: "") ? "" :reminderMessageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            event.reminderDate = nil
        }
    }
    
    private func setUpTextViews() {
        notesTextView.delegate = self
        notesTextView.text = NSLocalizedString("Notes", comment: "")
        notesTextView.textColor = UIColor.placeholderText
        notesTextView.textContainer.lineFragmentPadding = 0
        notesTextView.textContainerInset = .zero
        notesTextView.backgroundColor = .clear
        
        reminderMessageTextView.delegate = self
        reminderMessageTextView.text = NSLocalizedString("Reminder message", comment: "")
        reminderMessageTextView.textColor = UIColor.placeholderText
        reminderMessageTextView.textContainer.lineFragmentPadding = 0
        reminderMessageTextView.textContainerInset = .zero
        reminderMessageTextView.backgroundColor = .clear
    }
    
    private func updateUIIfInEditMode() {
        if isInEditMode {
            nameTextField.text = event.name
            datePicker.date = event.date!
            entireDaySwitch.isOn = event.isEntireDay
            
            if event.reminderDate != nil {
                reminderDatePicker.date = event.reminderDate!
                if event.reminderMessage != "" {
                    reminderMessageTextView.text = event.reminderMessage
                    reminderMessageTextView.textColor = .label
                }
                reminderSwitch.isOn = true
                reminderSwitchCell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
                tableView.beginUpdates()
                tableView.endUpdates()
            }
            
            eventRepetition = EventRepetition(rawValue: event.repetition)!
            if event.notes != "" {
                notesTextView.text = event.notes
                notesTextView.textColor = .label
            }
        }
    }
    
    private func addTableViewGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tap)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeUp.direction = .up
        swipeUp.cancelsTouchesInView = false
        tableView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeDown.direction = .down
        swipeDown.cancelsTouchesInView = false
        tableView.addGestureRecognizer(swipeDown)
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
        notesTextView.resignFirstResponder()
        reminderMessageTextView.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }
}

extension AddEventViewController: RepetitionTableViewControllerDelegate {
    func updateRepetition(with indexPath: IndexPath) {
        eventRepetition = EventRepetition(rawValue: indexPath.row)!
    }
}

extension AddEventViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 2 else { return super.tableView(tableView, numberOfRowsInSection: section) }
        
        return isReminderSectionHidden ? 1 : 3
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
        guard self.view.window != nil else { return }
        
        if textView.textColor == UIColor.placeholderText {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
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
