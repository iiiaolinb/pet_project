import Foundation
import UIKit

protocol LastFilesViewModelProtocol {
    
}

final class LastFilesViewModel {
    typealias Route = FolderRoute & FileViewerRoute
    let networkDataFetcher = NetworkDataFetcher()
    private let router: Route
    var dataModel: [LastFilesModel]?

    init(router: Route) {
        self.router = router
    }
    
    func openFolderScreen(_ folderName: String) {
        router.openFolderScreen(folderName: folderName)
    }
    
    func openFileViewerScreen(_ fileName: String) {
        router.openFileViewerScreen(fileName)
    }
}

    //MARK: - получить информацию об опубликованных файлах

extension LastFilesViewModel {
    func getInfo() {
        let urlString: String = "https://cloud-api.yandex.net/v1/disk/resources/last-uploaded"
        networkDataFetcher.fetchDataLF(urlString: urlString) { [self] (info) in
            dataModel = info
            print("data model count - ", self.dataModel?.count)
        }
    }
    
    func loadPreviewImage(to imageView: UIImageView, from URLString: String) {
        networkDataFetcher.asyncLoadImage(imageView, urlString: URLString)
    }
}

