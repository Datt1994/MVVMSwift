

import UIKit

class HomeViewController: UIViewController {
    
    weak var mainCoordintor: MainCoordinator?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !LoginService.isAuthenticated {
            mainCoordintor?.presentLoginScene()
        }
    }
    
    @IBAction func logListButtonAction(_ sender: UIButton) {
        mainCoordintor?.toLogListScene()
    }
    
    @IBAction func moreInfoButtonAction(_ sender: UIButton) {
        mainCoordintor?.toMoreInfoScene()
    }
    
    @IBAction func logOutButtonAction(_ sender: UIButton) {
        LoginService.isAuthenticated.toggle()
        mainCoordintor?.presentLoginScene()
    }
    
}
