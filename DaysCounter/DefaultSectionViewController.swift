//
//  DefaultSectionViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 18/12/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit

class DefaultSectionViewController: UIViewController {

    var delegate: DefaultSectionViewControllerDelegate?
    
    private var tableView: UITableView!
    private var savedDefaultSection: Defaults.DefaultSection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receiveSavedDefaultValue()
        configureTableView()
    }
    
    private func receiveSavedDefaultValue() {
        savedDefaultSection = Defaults.getDefaultSection()
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "settingsCell")
        view.addSubview(tableView)
    }
}

extension DefaultSectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row ==  savedDefaultSection.rawValue {
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.endUpdates()
        UserDefaults.standard.set(indexPath.row, forKey: Defaults.Key.DefaultSection.rawValue)
        self.navigationController?.popViewController(animated: true)
        delegate?.updateDefaultSection(with: Defaults.DefaultSection(rawValue: indexPath.row)!)
    }
    
}

extension DefaultSectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Defaults.DefaultSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
        
        guard let sectionOption = Defaults.DefaultSection.init(rawValue: indexPath.row) else { return UITableViewCell() }
        cell.updateCellTitle(with: Defaults.DefaultSection.getOptionTitle(for: sectionOption))
        cell.updateCellSubtitle(with: "")
        
        return cell
    }
    
}

protocol DefaultSectionViewControllerDelegate {
    func updateDefaultSection(with option: Defaults.DefaultSection)
}

