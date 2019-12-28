//
//  BackupFile.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 27/12/2019.
//  Copyright © 2019 CloudDroid. All rights reserved.
//

import Foundation

class BackupFile {
    var displayName: String
    var path: URL
    
    init(filePath: URL) {
        self.path = filePath
        self.displayName = filePath.lastPathComponent
    }
}
