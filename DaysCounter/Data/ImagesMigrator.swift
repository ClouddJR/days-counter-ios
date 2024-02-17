import Foundation


/// Migrates images stored in a documents folder to the shared container
/// and fixes local image paths in the database.
///
/// Images stored in a documents folder are only accessible by the app. By moving them
/// to the shared container, they can also be accessed from widgets. Additionally, the paths
/// stored in the database should be relative, because the app's UUID will be different
/// after each app update, causing the absolute path to be invalid.
///
/// This migration will only take effect on older apps. Newer versions save images
/// to the shared container by default and store correct paths in the database.
final class ImageMigrator {
    private let localDatabase: LocalDatabase
    private let remoteDatabase: RemoteDatabase
    private let userRepository: UserRepository
    
    private let legacyImagesPath: URL
    private let imagesPath: URL
    
    init(
        localDatabase: LocalDatabase = LocalDatabase(),
        remoteDatabase: RemoteDatabase = RemoteDatabase(),
        userRepository: UserRepository = UserRepository()
    ) {
        self.localDatabase = localDatabase
        self.remoteDatabase = remoteDatabase
        self.userRepository = userRepository
        
        self.legacyImagesPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appending(path: AppGroup.imagesDirectory)
        
        self.imagesPath = AppGroup.imagesDirectoryUrl
    }
    
    func migrate() {
        createDirectoryForImagesIfNecessary()
        
        localDatabase.getAllEvents()
            .filter("NOT localImagePath BEGINSWITH %@", AppGroup.imagesDirectory)
            .filter("NOT localImagePath BEGINSWITH %@", "pre-installed")
            .forEach { event in
                migrateImage(for: event)
            }
    }
    
    private func createDirectoryForImagesIfNecessary() {
        if !FileManager.default.fileExists(atPath: imagesPath.path()) {
            do {
                try FileManager.default.createDirectory(
                    atPath: imagesPath.path(),
                    withIntermediateDirectories: true
                )
            } catch {
                print("Error creating a directory for storing images: \(error)")
            }
        }
    }
    
    private func migrateImage(for event: Event) {
        let fileName = URL(string: event.localImagePath)!.lastPathComponent
        let currentImagePath = legacyImagesPath.appending(path: fileName).path()
        
        guard FileManager.default.fileExists(atPath: currentImagePath) else { return }
        
        let newImagePath = imagesPath.appending(path: fileName).path()
        
        do {
            try FileManager.default.moveItem(
                atPath: currentImagePath,
                toPath: newImagePath
            )
            localDatabase.updateLocalImagePath(forEvent: event, withPath: "\(AppGroup.imagesDirectory)/\(fileName)")
            if userRepository.isUserLoggedIn() {
                remoteDatabase.addOrUpdateEvent(event)
            }
        } catch {
            print("Error while migrating an image to the shared container: \(error).")
        }
    }
}
