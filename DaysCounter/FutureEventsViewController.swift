//
//  FutureEventsViewController.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 11/09/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import UIKit
import RealmSwift

class FutureEventsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let predicate = NSPredicate(format: "date > %@", NSDate())
        let results = realm.objects(Event.self).filter(predicate)
        print(results)
    }

}
