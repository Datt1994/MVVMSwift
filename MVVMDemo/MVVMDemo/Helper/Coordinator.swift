
import Foundation
import UIKit


protocol Coordinator: class {
    var childCoordinators: [Coordinator] {get set}
    var navigationCoordinator: UINavigationController {get set}
    
    func start()
}
