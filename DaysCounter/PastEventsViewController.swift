//
//  PastEventsViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 11/09/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit
import RealmSwift

class PastEventsViewController: UIViewController {
    
    var pastEvents: Results<Event>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let predicate = NSPredicate(format: "date < %@", NSDate())
        pastEvents = realm.objects(Event.self).filter(predicate)
    }
}

// MARK:  UITableViewDelegate

extension PastEventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK:  UITableViewDataSource

extension PastEventsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastEvents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
