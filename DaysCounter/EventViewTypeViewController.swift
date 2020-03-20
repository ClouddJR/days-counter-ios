//
//  EventViewTypeViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 25/02/2020.
//  Copyright © 2020 CloudDroid. All rights reserved.
//

import UIKit

class EventViewTypeViewController: UIViewController {

    var delegate: EventViewTypeViewControllerDelegate?
    
    private var tableView: UITableView!
    private var savedEventViewType: Defaults.EventViewType!

    override func viewDidLoad() {
        super.viewDidLoad()
        receiveSavedDefaultValue()
        configureTableView()
    }
    
    private func receiveSavedDefaultValue() {
        savedEventViewType = Defaults.getEventViewType()
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

extension EventViewTypeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row ==  savedEventViewType.rawValue {
            cell.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        tableView.endUpdates()
        UserDefaults.standard.set(indexPath.row, forKey: Defaults.Key.EventViewType.rawValue)
        self.navigationController?.popViewController(animated: true)
        delegate?.updateEventViewType(with: Defaults.EventViewType(rawValue: indexPath.row)!)
    }
    
}

extension EventViewTypeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Defaults.EventViewType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
        
        guard let eventViewType = Defaults.EventViewType.init(rawValue: indexPath.row) else { return UITableViewCell() }
        cell.updateCellTitle(with: Defaults.EventViewType.getOptionTitle(for: eventViewType))
        cell.updateCellSubtitle(with: "")
        
        return cell
    }
    
}

protocol EventViewTypeViewControllerDelegate {
    func updateEventViewType(with option: Defaults.EventViewType)
}

