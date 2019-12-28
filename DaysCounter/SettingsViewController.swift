//
//  SettingsViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 16/12/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit
import MessageUI
import RealmSwift

class SettingsViewController: UIViewController {
    
    let realm = try! Realm()
    
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
        guard let section = SettingsSection(rawValue: indexPath.section) else { return}
        
        switch section {
        case .General:
            let generalSection = GeneralSection(rawValue: indexPath.row)!
            switch generalSection {
            case .SortingOrder:
                let vc = SortingOrderViewController()
                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
            case .DefaultSection:
                let vc = DefaultSectionViewController()
                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
            default: return
            }
//        case .Backup:
//            let backupSection = BackupSection(rawValue: indexPath.row)!
//            switch backupSection {
//            case .ExportEvents:
//                exportEvents()
//            case .ImportEvents:
//                importEvents()
//            }
            return
        case .About:
            let aboutSection = AboutSection(rawValue: indexPath.row)!
            switch aboutSection {
            case .PrivacyPolicy:
                openPrivacyPolicyPage()
            case .ContactMe:
                showEmailComposer()
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func exportEvents() {
        let paths = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
        if let filePath = getFirstPathWithAppendedFileName(from: paths) {
            do {
                try realm.writeCopy(toFile: filePath)
                print("Saved to: \(filePath.absoluteString)")
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func getFirstPathWithAppendedFileName(from paths: [URL]) -> URL? {
        if var firstPath = paths.first {
            firstPath = firstPath.appendingPathComponent("backups")
            if !FileManager.default.fileExists(atPath: firstPath.path) {
                do {
                    try FileManager.default.createDirectory(atPath: firstPath.path, withIntermediateDirectories: true)
                } catch {
                    print("Error \(error)")
                }
            }
            return firstPath.appendingPathComponent("test.realm")
        } else {
            return nil
        }
    }
    
    private func importEvents() {
        let vc = BackupFolderBrowserViewController(initialPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openPrivacyPolicyPage() {
        let policyURL = "https://sites.google.com/view/dcprivacypolicy"
        if let url = URL(string: policyURL) {
            UIApplication.shared.open(url)
        }
    }
    
    private func showEmailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            showErrorAlert(with: "Can't send email from this device.")
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["arekchmura@gmail.com"])
        composer.setSubject("Days Counter app")
        
        present(composer, animated: true)
    }
    
    private func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true)
            return
        }
        
        controller.dismiss(animated: true)
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
//        case .Backup: return BackupSection.allCases.count
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
//        case .Backup:
//            cell.updateCellTitle(with: BackupSection.getOptionTitle(for: BackupSection(rawValue: indexPath.row)!))
//            cell.updateCellSubtitle(with: BackupSection.getOptionSubtitle(for: BackupSection(rawValue: indexPath.row)!))
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
