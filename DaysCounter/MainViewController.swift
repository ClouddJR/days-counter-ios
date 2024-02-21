import UIKit

final class MainViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        styleNavigationBar()
        
        ImageMigrator().migrate()
        fetchEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(
            self,
            name:  UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    private func styleNavigationBar() {
        navigationBar.shadowImage = UIImage()
    }
    
    @objc func didBecomeActive(_ notification: Notification)  {
        guard notification.name == UIApplication.didBecomeActiveNotification else { return }
        
        fetchEvents()
    }
    
    private func fetchEvents() {
        DatabaseRepository().fetchEventsFromTheCloud()
    }
}
