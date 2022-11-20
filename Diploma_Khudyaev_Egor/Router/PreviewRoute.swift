import UIKit

protocol PreviewRoute {
    func makePreviewScreen() -> UIViewController
}

extension PreviewRoute where Self: RouterProtocol {
    func makePreviewScreen() -> UIViewController {
        let router = Router(rootTransition: Transition())
        let viewModel = PreviewViewModel(router: router)
        let viewController = PreviewViewController(viewModel: viewModel)
        router.root = viewController

        let navigation = UINavigationController(rootViewController: viewController)
        //navigation.tabBarItem = UITabBarItem(title: "New transition", image: nil, tag: 1)
        return navigation
    }

    func selectListTab() {
        root?.tabBarController?.selectedIndex = 1
    }
}

extension Router: PreviewRoute {}
