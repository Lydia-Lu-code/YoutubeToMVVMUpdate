import UIKit

class CustomPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let width = containerView.bounds.width * 0.75
        let frame = CGRect(x: 0, y: 0, width: width, height: containerView.bounds.height)
        return frame
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView, let presentedView = presentedView else {
            return
        }
        
        let dimView = UIView(frame: containerView.bounds)
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimView.alpha = 0
        containerView.insertSubview(dimView, at: 0)
        
        presentedView.frame = frameOfPresentedViewInContainerView
        presentedView.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                dimView.alpha = 1
            })
        } else {
            dimView.alpha = 1
        }
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
    }
}
