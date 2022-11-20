import UIKit

protocol ProfileRoute {
    func makeProfileScreen() -> UIViewController
}

extension ProfileRoute where Self: RouterProtocol {
    func makeProfileScreen() -> UIViewController {
        let router = Router(rootTransition: Transition())
        let viewModel = ProfileViewModel(router: router)
        let viewController = ProfileViewController(viewModel: viewModel)
        router.root = viewController

        let navigation = UINavigationController(rootViewController: viewController)
        navigation.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "profile"), tag: 0)
        return navigation
    }

    func selectListTab() {
        root?.tabBarController?.selectedIndex = 0
    }
}

extension Router: ProfileRoute {}
