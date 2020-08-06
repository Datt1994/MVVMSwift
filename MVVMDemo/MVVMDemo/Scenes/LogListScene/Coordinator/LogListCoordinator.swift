

import UIKit


class LogListCoordinator: Coordinator {
    
    weak var parentCoordinator: MainCoordinator?
    
    var childCoordinators = [Coordinator]()
    var navigationCoordinator: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationCoordinator = navigationController
    }

    func start() {
        let LogListVC: LogListViewController = LogListViewController.instantiate(storyboard: .main)
        LogListVC.logListCoordinator = self
        navigationCoordinator.pushViewController(LogListVC, animated: true)
    }
    public func showLogDetail() {
      
    }
}
