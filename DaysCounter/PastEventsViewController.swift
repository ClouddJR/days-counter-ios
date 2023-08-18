import UIKit
import RealmSwift

class PastEventsViewController: UIViewController {
    
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
}

// MARK:  UITableViewDelegate

extension PastEventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "eventDetailsViewController") as! EventDetailsViewController
        vc.eventId = pastEvents[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK:  UITableViewDataSource

extension PastEventsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        cell.updateCellView(with: pastEvents[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
