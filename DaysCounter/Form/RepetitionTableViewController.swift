import UIKit

class RepetitionTableViewController: UITableViewController {
    
    var delegate: RepetitionTableViewControllerDelegate?
    var previousSelection: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == previousSelection {
            cell.accessoryType = .checkmark
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.endUpdates()
        self.navigationController?.popViewController(animated: true)
        delegate?.updateRepetition(with: indexPath)
    }
    
}

protocol RepetitionTableViewControllerDelegate {
    func updateRepetition(with indexPath: IndexPath)
}
