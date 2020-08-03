

import UIKit

class ViewController: UIViewController {
    
    private var transitionCordinator = LockAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !LoginService.isAuthenticated {
            presentLoginViewController()
        }
    }
}

// MARK: Private Methods
private extension ViewController {
    func presentLoginViewController(completion: (() -> Void)? = nil) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.transitioningDelegate = transitionCordinator
        loginVC.loginSuccess = { [weak loginVC] in
            //      self.activityIndicator.startAnimating()
            loginVC?.dismiss(animated: true)
        }
        
        present(loginVC, animated: true, completion: completion)
    }
}
