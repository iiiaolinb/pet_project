import UIKit

protocol LoginRoute {
    func openLoginScreen()
}

extension LoginRoute where Self: RouterProtocol {
    func openLoginScreen(with transition: TransitionProtocol) {
        let router = Router(rootTransition: transition)
        let viewModel = LoginViewModel(router: router)
        let viewController = LoginViewController(viewModel: viewModel)
        //let navigationController = UINavigationController(rootViewController: viewController)
        router.root = viewController
        route(to: viewController, with: transition)
    }
    
    func openLoginScreen() {
        openLoginScreen(with: PushTransition())
    }
}

extension Router: LoginRoute {}
