import UIKit

final class AnimatedLogoutTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        present(using: transitionContext)
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3
    }

    internal func present(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
              let fromVC = transitionContext.viewController(forKey: .from),
              let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) else { return }

        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        snapshot.frame = finalFrame
        snapshot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)

        toVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransform(for: containerView)
        snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 1,
                                options: .calculationModeCubic,
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 0,
                               relativeDuration: 1/3) {
            }
            
            UIView.addKeyframe(withRelativeStartTime: 1/3,
                               relativeDuration: 1/3) {
                fromVC.view.layer.transform = AnimationHelper.yRotation(-.pi / 2)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 2/3,
                               relativeDuration: 1/3) {
                snapshot.layer.transform = AnimationHelper.yRotation(0)
            }
        },
                                completion: { _ in
                toVC.view.isHidden = false
                snapshot.removeFromSuperview()
                fromVC.view.layer.transform = CATransform3DIdentity
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.isHidden = true
        })
    }

    internal func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }

        let conteinerView = transitionContext.containerView
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromView.alpha = 0.0
        })
    }
}

