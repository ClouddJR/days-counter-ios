import UIKit
import RealmSwift

final class PastEventsViewController: UIViewController {
    let databaseRepository = DatabaseRepository()
    var pastEvents: Results<Event>!
    
    private var sortingOrderUserDefaultsObserver: NSKeyValueObservation?
    private var eventViewTypeUserDefaultsObserver: NSKeyValueObservation?
    
    var notificationToken: NotificationToken?
    
    private lazy var tableView: UITableView = {
        return createTableView()
    }()
    
    private func createTableView() -> UITableView {
        let tableView = UITableView()
        let cellClass = Defaults.getEventViewType() == .large ? LargeEventCell.self : CompactEventCell.self
        tableView.register(cellClass, forCellReuseIdentifier: "EventCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = Defaults.getEventViewType() == .large ? 200 : 86
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPastEvents()
        addTableViewAsSubview()
        sortEvents()
        listenForDataChanges()
        registerUserDefaultsObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        sortingOrderUserDefaultsObserver?.invalidate()
        sortingOrderUserDefaultsObserver = nil
        
        eventViewTypeUserDefaultsObserver?.invalidate()
        eventViewTypeUserDefaultsObserver = nil
    }
    
    private func getPastEvents() {
        pastEvents = databaseRepository.getPastEvents()
    }
    
    private func addTableViewAsSubview() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
    }
    
    private func sortEvents() {
        let sortingOrder = Defaults.getSortingOrder()
        switch sortingOrder {
        case .daysAscending: pastEvents = pastEvents.sorted(byKeyPath: "date", ascending: false)
        case .daysDescending: pastEvents = pastEvents.sorted(byKeyPath: "date", ascending: true)
        case .timeAdded: pastEvents = pastEvents.sorted(byKeyPath: "createdAt", ascending: true)
        }
    }
    
    private func listenForDataChanges() {
        self.notificationToken = pastEvents.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                break
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
            case .error(let err):
                fatalError("\(err)")
            }
        }
    }
    
    private func registerUserDefaultsObserver() {
        sortingOrderUserDefaultsObserver = UserDefaults.standard.observe(\.user_defaults_sorting_order, options: [.new], changeHandler: { [weak self] (defaults, change) in
            self?.sortEvents()
            self?.tableView.reloadData()
        })
        
        eventViewTypeUserDefaultsObserver = UserDefaults.standard.observe(\.user_defaults_event_view_type, options: [.new], changeHandler: { [weak self] (defaults, change) in
            guard (self != nil) else {return}
            self!.tableView.removeFromSuperview()
            self!.tableView = self!.createTableView()
            self!.addTableViewAsSubview()
        })
    }
    
    private func showEmptyView() {
        var config = UIContentUnavailableConfiguration.empty()
        config.image = .init(systemName: "calendar.badge.plus")
        config.text = "No Past Events"
        config.secondaryText = "Events you add will appear here."
        
        var buttonConfig = UIButton.Configuration.tinted()
        buttonConfig.title = "Add event"
        config.button = buttonConfig
        config.buttonProperties.primaryAction = UIAction { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "addEventNavigationController") as! UINavigationController
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.present(vc, animated: true)
        }
        
        let emptyView = UIContentUnavailableView(configuration: config)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
        container.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
        
        tableView.backgroundView = container
    }
}

extension PastEventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "eventDetailsViewController") as! EventDetailsViewController
        vc.eventId = pastEvents[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        configureContextMenu(index: indexPath.row)
    }
    
    private func configureContextMenu(index: Int) -> UIContextMenuConfiguration{
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            let edit = UIAction(
                title: "Edit",
                image: UIImage(systemName: "square.and.pencil")
            ) { _ in
                self.goToEditScreen(event: self.pastEvents[index])
            }
            
            let delete = UIAction(
                title: "Delete",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                self.displayAlertAndDeleteIfConfirmed(event: self.pastEvents[index])
            }
            
            return UIMenu(options: .displayInline, children: [edit, delete])
            
        }
        return context
    }
    
    private func goToEditScreen(event: Event) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "addEventNavigationController") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        if let addVc = vc.children.first as? AddEventViewController {
            addVc.event = Event(value: event)
            addVc.isInEditMode = true
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    private func displayAlertAndDeleteIfConfirmed(event: Event) {
        let alert = UIAlertController(title: NSLocalizedString("Are you sure you want to delete this event?", comment: ""), message: NSLocalizedString("This operation cannot be undone.", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { (action) in
            self.cancelNotification(event: event)
            self.databaseRepository.deleteEvent(event: event)
        }))
        self.present(alert, animated: true)
    }
    
    private func cancelNotification(event: Event) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [event.id!])
    }
}

extension PastEventsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pastEvents.count == 0 {
            showEmptyView()
        } else {
            tableView.backgroundView = nil
        }
        
        return pastEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        cell.updateCellView(with: pastEvents[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
