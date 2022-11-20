import UIKit

protocol AnimatedTransitionProtocol {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    func present(using transitionContext: UIViewControllerContextTransitioning)
    func dismiss(using transitionContext: UIViewControllerContextTransitioning)
    var isPresenting: Bool {get set}
}
