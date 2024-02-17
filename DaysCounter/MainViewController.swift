import UIKit

final class MainViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        styleNavigationBar()
        
        ImageMigrator().migrate()
        DatabaseRepository().fetchEventsFromTheCloud()
    }
    
    private func styleNavigationBar() {
        navigationBar.shadowImage = UIImage()
    }
}
