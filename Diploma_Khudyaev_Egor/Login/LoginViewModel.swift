import Foundation

final class LoginViewModel {
    private let router: MainScreenRoute

    init(router: MainScreenRoute) {
        self.router = router
    }
    
    func openMainScreen() {
        router.openMainScreen()
    }
}
