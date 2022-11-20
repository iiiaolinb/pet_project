import Foundation
import UIKit

final class RenameViewModel {
    private let router: Closable
    let networkDataFetcher = NetworkDataFetcher()

    init(router: Closable) {
        self.router = router
    }
    
    func close() {
        router.close()
    }
    
    func rename(urlString: String) {
        networkDataFetcher.rename(urlString: urlString)
    }
    
    func loadPreviewImage(to imageView: UIImageView, from URLString: String) {
        networkDataFetcher.asyncLoadImage(imageView, urlString: URLString)
    }
}
