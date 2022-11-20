import UIKit

protocol LastFilesRoute {
    func makeLastFilesScreen() -> UIViewController
}

extension LastFilesRoute where Self: RouterProtocol {
    func makeLastFilesScreen() -> UIViewController {
        let router = Router(rootTransition: Transition())
        let viewModel = LastFilesViewModel(router: router)
        let viewController = LastFilesViewController(viewModel: viewModel)
        router.root = viewController

        let navigation = UINavigationController(rootViewController: viewController)
        navigation.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "lastFiles"), tag: 1)
        return navigation
    }

    func selectListTab() {
        root?.tabBarController?.selectedIndex = 1
    }
}

extension Router: LastFilesRoute {}
