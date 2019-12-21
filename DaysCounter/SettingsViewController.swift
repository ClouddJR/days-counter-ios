//
//  SettingsViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 16/12/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var tableView: UITableView!
    
    @IBAction func dismiss(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    private func configureUI() {
        navigationItem.title = "Settings"
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "settingsCell")
        view.addSubview(tableView)
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = getSpecificOptionViewController(at: indexPath) {
            navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    private func getSpecificOptionViewController(at indexPath: IndexPath) -> UIViewController? {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return nil}
        
        switch section {
        case .General:
            let generalSection = GeneralSection(rawValue: indexPath.row)!
            switch generalSection {
            case .SortingOrder:
                let vc = SortingOrderViewController()
                vc.delegate = self
                return vc
            case .DefaultSection:
                let vc = DefaultSectionViewController()
                vc.delegate = self
                return vc
            default: return nil
            }
        case .Backup:
            return nil
        case .About:
            return nil
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingsSection(rawValue: section) else {return ""}
        return SettingsSection.getSectionTitle(for: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else {return 0}
        
        switch section {
        case .General: return GeneralSection.allCases.count
        case .Backup: return BackupSection.allCases.count
        case .About: return AboutSection.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
        
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .General:
            cell.updateCellTitle(with: GeneralSection.getOptionTitle(for: GeneralSection(rawValue: indexPath.row)!))
            cell.updateCellSubtitle(with: GeneralSection.getOptionSubtitle(for: GeneralSection(rawValue: indexPath.row)!))
        case .Backup:
            cell.updateCellTitle(with: BackupSection.getOptionTitle(for: BackupSection(rawValue: indexPath.row)!))
            cell.updateCellSubtitle(with: BackupSection.getOptionSubtitle(for: BackupSection(rawValue: indexPath.row)!))
        case .About:
            cell.updateCellTitle(with: AboutSection.getOptionTitle(for: AboutSection(rawValue: indexPath.row)!))
            cell.updateCellSubtitle(with: AboutSection.getOptionSubtitle(for: AboutSection(rawValue: indexPath.row)!))
        }
        
        return cell
    }
}

extension SettingsViewController: SortingOrderViewControllerDelegate {
    func updateSortingOrder(with option: Defaults.SortingOrder) {
        let cell = tableView.cellForRow(at: IndexPath(row: GeneralSection.SortingOrder.rawValue, section: 0)) as! SettingsTableViewCell
        cell.updateCellSubtitle(with: Defaults.SortingOrder.getOptionTitle(for: option))
    }
}

extension SettingsViewController: DefaultSectionViewControllerDelegate {
    func updateDefaultSection(with option: Defaults.DefaultSection) {
        let cell = tableView.cellForRow(at: IndexPath(row: GeneralSection.DefaultSection.rawValue, section: 0)) as! SettingsTableViewCell
        cell.updateCellSubtitle(with: Defaults.DefaultSection.getOptionTitle(for: option))
    }
}
