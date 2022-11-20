import Foundation

final class SampleVM {
    private let router: Closable

    init(router: Closable) {
        self.router = router
    }
    
    func dismiss() {
        router.close()
    }
}
