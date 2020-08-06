

import UIKit


protocol ViewContollerInstantiate {
    static func instantiate(storyboard: Storyboard) -> Self
}
extension UIViewController: ViewContollerInstantiate {}

extension ViewContollerInstantiate where Self: UIViewController {
    static func instantiate(storyboard: Storyboard) -> Self {
        let id = String(describing: Self.self)
        let vcStoryBoard = storyboard.storyboard
        let vc = vcStoryBoard.instantiateViewController(withIdentifier: id) as! Self
        return vc
    }
}

extension UIStoryboard {
    static func loadViewController<T>(name: String = String(describing: T.self), bundle: Bundle? = nil) -> T {
        return UIStoryboard(name: name, bundle: bundle).instantiateInitialViewController() as! T
    }
}
