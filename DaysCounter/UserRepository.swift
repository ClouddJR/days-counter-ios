//
//  UserRepository.swift
//  DaysCounter
//
//  Created by Arkadiusz Chmura on 19/02/2020.
//  Copyright © 2020 CloudDroid. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserRepository {
    
    func getUserId() -> String {
        if let user = Auth.auth().currentUser {
            return user.uid
        }
        return ""
    }
    
    func getUserEmail() -> String {
        if let user = Auth.auth().currentUser {
            return user.email ?? ""
        }
        return ""
    }
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("\(error)")
        }
    }
    
}
