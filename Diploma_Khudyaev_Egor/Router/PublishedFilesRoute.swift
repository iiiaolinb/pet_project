import UIKit

protocol PublishedFilesRoute {
    func openPublishedFilesScreen()
    func logOut()
}

extension PublishedFilesRoute where Self: RouterProtocol {
    func openPublishedFilesScreen(with transition: TransitionProtocol) {
        let router = Router(rootTransition: transition)
        let viewModel = PublishedFilesViewModel(router: router)
        let viewController = PublishedFilesViewController(viewModel: viewModel)
        router.root = viewController

        route(to: viewController, with: transition)
    }
    
    func openPublishedFilesScreen() {
        openPublishedFilesScreen(with: PushTransition())
    }
    
    func logOut(with transition: TransitionProtocol) {
        let router = Router(rootTransition: transition)
        let viewModel = LoginViewModel(router: router)
        let viewController = LoginViewController(viewModel: viewModel)
        router.root = viewController

        route(to: viewController, with: transition)
    }
    
    func logOut() {
        logOut(with: FlipTransition(animatedTransition: AnimatedFlipTransition(withLottie: false), isAnimated: true))
    }
}

extension Router: PublishedFilesRoute {}
