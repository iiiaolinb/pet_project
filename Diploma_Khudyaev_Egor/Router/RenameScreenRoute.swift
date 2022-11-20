import UIKit

protocol RenameScreenRoute {
    func openRenameScreen(_ file: FileViewerModel)
}

extension RenameScreenRoute where Self: RouterProtocol {
    func openRenameScreen(_ file: FileViewerModel, with transition: TransitionProtocol) {
        let router = Router(rootTransition: transition)
        let viewModel = RenameViewModel(router: router)
        let viewController = RenameViewController(viewModel: viewModel, file: file)
        router.root = viewController

        route(to: viewController, with: transition)
    }
    
    func openRenameScreen(_ file: FileViewerModel) {
        openRenameScreen(file, with: PushTransition())
    }
}

extension Router: RenameScreenRoute {}
