import UIKit

protocol FolderRoute {
    func openFolderScreen(folderName: String)
}

extension FolderRoute where Self: RouterProtocol {
    func openFolderScreen(folderName: String, with transition: TransitionProtocol) {
        let router = Router(rootTransition: transition)
        let viewModel = AllFilesViewModel(router: router)
        let viewController = AllFilesViewController(viewModel: viewModel, folderName: folderName)
        router.root = viewController

        route(to: viewController, with: transition)
    }
    
    func openFolderScreen(folderName: String) {
        openFolderScreen(folderName: folderName, with: PushTransition())
    }
}

extension Router: FolderRoute {}
