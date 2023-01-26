import Foundation
import Firebase
import FirebaseFirestoreSwift

class RemoteDatabase {
    
    let userRepository: UserRepository
    
    init(_ userRepository: UserRepository = UserRepository()) {
        self.userRepository = userRepository
    }
    
    func addOrUpdateEvent(_ event: Event) {
        let db =  Firestore.firestore()
        db.collection(userRepository.getUserId()).document(event.id!)
            .setData(getDataMap(for: event)) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
        }
    }
    
    func addImage(for event: Event) {
        if !EventOperator.doesEventContainsPreInstalledImage(event) &&
            FileManager.default.fileExists(atPath: event.localImagePath) {
            if event.cloudImagePath.isEmpty {
                setUpCloudImagePath(for: event)
            }
            
            let storageRef = Storage.storage().reference(withPath: event.cloudImagePath)
            storageRef.putFile(from: URL(fileURLWithPath: event.localImagePath), metadata: nil) { metadata, error in
                guard let metadata = metadata else {
                    return
                }
                let size = metadata.size
                print(size)
            }
        }
    }
    
    func getImage(for event: Event, finishedListener: @escaping( (URL) -> ())) {
        let storageRef = Storage.storage().reference(withPath: event.cloudImagePath)
        if let filePath = EventOperator.getFilePathWithAppendedFileName() {
            storageRef.write(toFile: filePath) { url, error in
              if let error = error {
                print("Error downloading an image: \(error)")
              } else {
                finishedListener(filePath)
              }
            }
        }
    }
    
    private func setUpCloudImagePath(for event: Event) {
        let imageName = URL(fileURLWithPath: event.localImagePath).lastPathComponent
        let path = "\(userRepository.getUserId())/\(event.id!)/\(imageName)"
        event.cloudImagePath = path
    }
    
    func deleteImage(for event: Event) {
        let storageRef = Storage.storage().reference(withPath: event.cloudImagePath)
        storageRef.delete { _ in
            // nop
        }
    }
    
    func addEvents(_ events: [Event], finishedListener: @escaping( () -> ())) {
        //A batched write can contain up to 500 operations
        let db =  Firestore.firestore()
        
        if events.isEmpty {
            finishedListener()
            return
        }
        
        events.chunked(into: 495).forEach { slice in
            let batch = db.batch()
            slice.forEach { event in
                let document = db.collection(userRepository.getUserId()).document(event.id!)
                batch.setData(getDataMap(for: event), forDocument: document)
            }
            batch.commit { err in
                if let err = err {
                    print("Error: \(err)")
                } else {
                    finishedListener()
                }
            }
        }
    }
    
    private func getDataMap(for event: Event) -> [String: Any] {
        return [
            "id": event.id!,
            "name": event.name!,
            "date": event.date!,
            "isEntireDay": event.isEntireDay,
            "notes": event.notes,
            "repetition": event.repetition,
            "reminderMessage": "",
            "localImagePath": event.localImagePath,
            "cloudImagePath": event.cloudImagePath,
            "areYearsIncluded": event.areYearsIncluded,
            "areMonthsIncluded": event.areMonthsIncluded,
            "areWeeksIncluded": event.areWeeksIncluded,
            "areDaysIncluded": event.areDaysIncluded,
            "isTimeIncluded": event.isTimeIncluded,
            "fontColor": event.fontColor as Any,
            "fontType": event.fontType,
            "imageDim": event.imageDim,
            "createdAt": event.createdAt,
        ]
    }
    
    func deleteEvent(with id: String) {
        let db =  Firestore.firestore()
        db.collection(userRepository.getUserId()).document(id).delete()
    }
    
    func getEvents(finishedListener: @escaping( ([Event]) -> ())) {
        let db =  Firestore.firestore()
        let docRef = db.collection(userRepository.getUserId())
        
        docRef.getDocuments() { (querySnapshot, err) in
            if err == nil {
                var events: [Event] = []
                for document in querySnapshot!.documents {
                    let result = Result {
                        try document.data(as: Event.self)
                    }
                    switch result {
                    case .success(let event):
                        events.append(event)
                    case .failure(let error):
                        print("Error decoding event: \(error)")
                    }
                }
                finishedListener(events)
            }
        }
    }
}
