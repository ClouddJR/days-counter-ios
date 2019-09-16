//
//  AddEventViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 13/09/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UITextViewDelegate, UITableViewDelegate {
    
    var tableViewController: UITableViewController? {
        return children.compactMap({ $0 as? UITableViewController }).first
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
}
