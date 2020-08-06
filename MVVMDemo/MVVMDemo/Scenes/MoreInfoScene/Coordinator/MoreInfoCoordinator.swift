
import UIKit


class MoreInfoCoordinator: Coordinator {
    
    weak var parentCoordinator: MainCoordinator?
    
    var childCoordinators = [Coordinator]()
    var navigationCoordinator: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationCoordinator = navigationController
    }

    func start() {
        let moreInfoVC: MoreInfoViewController = MoreInfoViewController.instantiate(storyboard: .main)
        moreInfoVC.moreInfoCoordinator = self
        navigationCoordinator.pushViewController(moreInfoVC, animated: true)
    }
    public func showOther() {
      
    }
}
