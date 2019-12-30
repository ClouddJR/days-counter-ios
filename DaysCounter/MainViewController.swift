//
//  MainViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 30/12/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit

class MainViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleNavigationBar()
    }
    
    private func styleNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
}
