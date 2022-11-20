import UIKit

protocol AllFilesRoute {
    func makeAllFilesScreen() -> UIViewController
}

extension AllFilesRoute where Self: RouterProtocol {
    func makeAllFilesScreen() -> UIViewController {
        let router = Router(rootTransition: Transition())
        let viewModel = AllFilesViewModel(router: router)
        let viewController = AllFilesViewController(viewModel: viewModel, folderName: "")
        router.root = viewController

        let navigation = UINavigationController(rootViewController: viewController)
        navigation.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "allFiles"), tag: 2)
        return navigation
    }

    func selectListTab() {
        root?.tabBarController?.selectedIndex = 2
    }
}

extension Router: AllFilesRoute {}
