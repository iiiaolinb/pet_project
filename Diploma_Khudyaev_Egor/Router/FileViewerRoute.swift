import UIKit

protocol FileViewerRoute {
    func openFileViewerScreen(_ file: String)
}

extension FileViewerRoute where Self: RouterProtocol {
    func openFileViewerScreen(_ file: String, with transition: TransitionProtocol) {
        let router = Router(rootTransition: transition)
        let viewModel = FileViewerViewModel(router: router)
        let viewController = FileViewerViewController(viewModel: viewModel, folderName: file)
        router.root = viewController

        route(to: viewController, with: transition)
    }
    
    func openFileViewerScreen(_ file: String) {
        openFileViewerScreen(file, with: PushTransition())
    }
}

extension Router: FileViewerRoute {}


