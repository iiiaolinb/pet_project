import UIKit

final class PreviewViewModel {
    private let router: LoginRoute
    
    static var defaults: UserDefaults = {
        let defaults = UserDefaults.standard
        return defaults
    }()

    init(router: LoginRoute) {
        self.router = router
    }
    
    func openLoginScreen() {
        router.openLoginScreen()
    }
    
    func isPresent() -> Bool {
        return !PreviewViewModel.defaults.bool(forKey: Keys.isPresent.rawValue)
    }
}
