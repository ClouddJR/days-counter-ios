//
//  MainViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 30/12/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit

class MainViewController: UINavigationController {
    
    private var databaseRepository: DatabaseRepository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleNavigationBar()
        databaseRepository = DatabaseRepository()
        databaseRepository.fetchEventsFromTheCloud()
    }
    
    private func styleNavigationBar() {
        navigationBar.shadowImage = UIImage()
    }
}
