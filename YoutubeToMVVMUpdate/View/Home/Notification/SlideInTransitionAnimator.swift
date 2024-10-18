import UIKit

class SlideInTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView

        if isPresenting {
            containerView.addSubview(toViewController.view)
            toViewController.view.frame = containerView.bounds
            toViewController.view.frame.origin.x = -containerView.frame.width
        }

        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, animations: {
            if self.isPresenting {
                toViewController.view.frame.origin.x = 0
            } else {
                fromViewController.view.frame.origin.x = -containerView.frame.width
            }
        }) { finished in
            let success = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(success)
        }
    }
}

