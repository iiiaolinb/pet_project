import UIKit

protocol MainScreenRoute {
    func openMainScreen()
}

extension MainScreenRoute where Self: RouterProtocol {
    func openMainScreen(with transition: TransitionProtocol) {
        let router = Router(rootTransition: transition)
        let tabs = [router.makeProfileScreen(), router.makeLastFilesScreen(), router.makeAllFilesScreen()]
        let tabBar = UITabBarController()
        tabBar.viewControllers = tabs
        router.root = tabBar
        

        route(to: tabBar, with: transition)
    }
    
    func openMainScreen() {
        openMainScreen(with: FlipTransition(animatedTransition: AnimatedFlipTransition(withLottie: true), isAnimated: true))
    }
}

extension Router: MainScreenRoute {}
