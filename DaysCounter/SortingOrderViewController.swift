import UIKit

class SortingOrderViewController: UIViewController {

    var delegate: SortingOrderViewControllerDelegate?
    
    private var tableView: UITableView!
    private var savedSortingOrder: Defaults.SortingOrder!

    override func viewDidLoad() {
        super.viewDidLoad()
        receiveSavedDefaultValue()
        configureTableView()
    }
    
    private func receiveSavedDefaultValue() {
        savedSortingOrder = Defaults.getSortingOrder()
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "settingsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension SortingOrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row ==  savedSortingOrder.rawValue {
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.endUpdates()
        UserDefaults.standard.set(indexPath.row, forKey: Defaults.Key.SortingOrder.rawValue)
        self.navigationController?.popViewController(animated: true)
        delegate?.updateSortingOrder(with: Defaults.SortingOrder(rawValue: indexPath.row)!)
    }
    
}

extension SortingOrderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Defaults.SortingOrder.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
        
        guard let sortingOption = Defaults.SortingOrder.init(rawValue: indexPath.row) else { return UITableViewCell() }
        cell.updateCellTitle(with: Defaults.SortingOrder.getOptionTitle(for: sortingOption))
        cell.updateCellSubtitle(with: "")
        
        return cell
    }
    
}

protocol SortingOrderViewControllerDelegate {
    func updateSortingOrder(with option: Defaults.SortingOrder)
}
