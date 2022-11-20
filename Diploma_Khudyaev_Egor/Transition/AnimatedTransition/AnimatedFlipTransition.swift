import UIKit
import Lottie

final class AnimatedFlipTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool = true
    var withLottie: Bool = true
    
    init(withLottie: Bool) {
        //self.isPresenting = isPresenting
        self.withLottie = withLottie
    }
    
    lazy var animationView: AnimationView = {
        var animation = AnimationView()
        animation = .init(name: "correct")
        let x = UIScreen.main.bounds.width
        let y = UIScreen.main.bounds.height
        animation.frame = CGRect(x: x/2 - x/8, y: y/3 - y/8, width: x/4, height: y/4)
        animation.contentMode = .scaleAspectFit
        animation.animationSpeed = 2
        return animation
    }()

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if withLottie {
            present(using: transitionContext)
        } else {
            dismiss(using: transitionContext)
        }
    }

    internal func present(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
              let fromVC = transitionContext.viewController(forKey: .from),
              let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) else { return }

        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        snapshot.frame = finalFrame
        snapshot.layer.masksToBounds = true
        fromVC.view.addSubview(self.animationView)
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)

        toVC.view.isHidden = true
        
        AnimationHelper.perspectiveTransform(for: containerView)
        snapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
        
        self.animationView.play()
        
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
                                delay: 0,
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
}
