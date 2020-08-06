

import UIKit


enum Storyboard {
    case main
    case home
    
    var storyboard: UIStoryboard {
        var storyboardName: String!
        switch self {
        case .main:
            storyboardName = "Main"
        case .home:
            storyboardName = "Home"
        }
        return UIStoryboard(name: storyboardName, bundle: Bundle.main)
    }
}
