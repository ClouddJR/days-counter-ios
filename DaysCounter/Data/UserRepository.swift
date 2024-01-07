import Foundation
import FirebaseAuth

final class UserRepository {
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
