
import UIKit



class MainCoordinator: NSObject,Coordinator {
    
    // MARK: - Properties
    let window: UIWindow?
    
    var childCoordinators = [Coordinator]()
    var navigationCoordinator: UINavigationController
    
    private var transitionCordinator = LockAnimator()

    init(navigationController: UINavigationController, window: UIWindow?) {
        self.navigationCoordinator = navigationController
        self.window = window
    }

    func start() {
        
        guard let window = window else {return}

        window.rootViewController = navigationCoordinator
        window.makeKeyAndVisible()
        
        let homeVC: HomeViewController = HomeViewController.instantiate(storyboard: .main)
        homeVC.mainCoordintor = self
        
        navigationCoordinator.delegate = self
        navigationCoordinator.pushViewController(homeVC, animated: false)
        
    }
    func toLogListScene() {
        let child = LogListCoordinator(navigationController: navigationCoordinator)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    func toMoreInfoScene() {
        let child = MoreInfoCoordinator(navigationController: navigationCoordinator)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func presentLoginScene(completion: (() -> Void)? = nil) {
        let loginVC = LoginViewController.instantiate(storyboard: .main)
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.transitioningDelegate = transitionCordinator
        loginVC.loginSuccess = { [weak loginVC] in
            loginVC?.dismiss(animated: true)
        }
        
        navigationCoordinator.present(loginVC, animated: true, completion: completion)
    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
extension MainCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        if let logListVC = fromViewController as? LogListViewController {
            childDidFinish(logListVC.logListCoordinator)
        }
        if let moreInfoVC = fromViewController as? MoreInfoViewController {
            childDidFinish(moreInfoVC.moreInfoCoordinator)
        }
        
    }
}
