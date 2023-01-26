import UIKit

class MainViewController: UINavigationController {
    
    private var databaseRepository: DatabaseRepository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleNavigationBar()
        databaseRepository = DatabaseRepository()
        databaseRepository.fetchEventsFromTheCloud()
    }
    
    private func styleNavigationBar() {
        navigationBar.shadowImage = UIImage()
    }
}
