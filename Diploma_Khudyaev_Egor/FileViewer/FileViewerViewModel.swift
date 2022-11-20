import Foundation
import UIKit

final class FileViewerViewModel {
    private let router: RenameScreenRoute
    let networkDataFetcher = NetworkDataFetcher()
    var dataModel: FileViewerModel?

    init(router: RenameScreenRoute) {
        self.router = router
    }
    
    func loadImage(fromURL: String) -> UIImage {
        return networkDataFetcher.loadImage(fromURL)
    }
    
    func delete(urlString: String) {
        let baseURL = "https://cloud-api.yandex.net/v1/disk/resources?path="
        networkDataFetcher.delete(urlString: baseURL + urlString)
    }
    
    func openRenameScreen(_ file: FileViewerModel) {
        router.openRenameScreen(file)
    }
    
    func getMetaInfo(folderName: String) {
        let urlMetaString: String = "https://cloud-api.yandex.net/v1/disk/resources?path=/\(folderName)"
        networkDataFetcher.fetchDataFV(urlString: urlMetaString) { [self] (metaInfo) in
            dataModel = metaInfo
            print("data model count - ", self.dataModel?.name)
        }
    }
}
