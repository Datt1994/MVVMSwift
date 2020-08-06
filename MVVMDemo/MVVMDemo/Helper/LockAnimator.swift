
import UIKit

class LockAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.9
    var isPresenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let loginVC = isPresenting ? toVC as! LoginViewController : transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! LoginViewController
        
        containerView.addSubview(toVC.view)
        containerView.bringSubviewToFront(loginVC.view)
        
        var topFromFrame = loginVC.topVaultView.frame
        topFromFrame.origin.y = isPresenting ? -topFromFrame.height - loginVC.lockView.frame.height/2 : 0
        
        var topToFrame = loginVC.topVaultView.frame
        topToFrame.origin.y = isPresenting ? 0 : -topFromFrame.height - loginVC.lockView.frame.height/2
        
        var bottomFromFrame = loginVC.bottomVaultView.frame
        bottomFromFrame.origin.y = isPresenting ? containerView.frame.height : containerView.frame.height - bottomFromFrame.height
        
        var bottomToFrame = loginVC.bottomVaultView.frame
        bottomToFrame.origin.y = isPresenting ? containerView.frame.height - bottomFromFrame.height : containerView.frame.height
        
        loginVC.topVaultView.frame = topFromFrame
        loginVC.bottomVaultView.frame = bottomFromFrame
        
        UIView.animate(withDuration: duration, delay:0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
                        loginVC.topVaultView.frame = topToFrame
                        loginVC.bottomVaultView.frame = bottomToFrame
        }, completion: { finished in
            transitionContext.completeTransition(true)
        }
        )
    }
}

extension LockAnimator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}

