import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCellTitle(with title: String) {
        textLabel?.text = title
    }
    
    func updateCellSubtitle(with subtitle: String) {
        if subtitle.isEmpty {
            accessoryType = .none
        }
        detailTextLabel?.text = subtitle
    }

}
