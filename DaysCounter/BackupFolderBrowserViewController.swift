//
//  BackupFolderBrowserViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 27/12/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit

class BackupFolderBrowserViewController: UIViewController {
    
    var delegate: BackupFolderBrowserDelegate?
    
    private var initialPath: URL!
    private let fileManager = FileManager.default
    private var files = [BackupFile]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        return tableView
    }()
    
    init(initialPath: URL) {
        super.init(nibName: nil, bundle: nil)
        self.initialPath = initialPath
        getFilesForInitialPath()
        print(files)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
    
    private func getFilesForInitialPath() {
        var filePaths = [URL]()
        do  {
            filePaths = try fileManager.contentsOfDirectory(at: initialPath, includingPropertiesForKeys: [], options: [.skipsHiddenFiles])
        } catch {
            return
        }
        
        for filePath in filePaths {
            let backupFile = BackupFile(filePath: filePath)
            if !backupFile.displayName.isEmpty {
                files.append(backupFile)
            }
        }
    }
}


extension BackupFolderBrowserViewController: UITableViewDelegate {
    
}

extension BackupFolderBrowserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = files[indexPath.row].displayName
        return cell
    }
}

protocol BackupFolderBrowserDelegate {
    func onFileChosen(filePath: URL)
}
