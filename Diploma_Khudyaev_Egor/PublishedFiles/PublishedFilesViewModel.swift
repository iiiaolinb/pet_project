import Foundation
import UIKit
//import Alamofire
//import CoreData

protocol PublishedFilesViewModelProtocol {
    
}

final class PublishedFilesViewModel: NSObject, PublishedFilesViewModelProtocol {
    typealias Route = PublishedFilesRoute & FolderRoute & FileViewerRoute
    let networkDataFetcher = NetworkDataFetcher()
    private let router: Route
    var dataModel: [PublishedFilesModel]?

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
extension PublishedFilesViewModel {
    func getInfo() {
        let urlString: String = "https://cloud-api.yandex.net/v1/disk/resources/public"
        networkDataFetcher.fetchDataPF(urlString: urlString) { [self] (info) in
            dataModel = info
            print("data model count - ", self.dataModel?.count)
        }
    }
    
    func loadPreviewImage(to imageView: UIImageView, from URLString: String) {
        networkDataFetcher.asyncLoadImage(imageView, urlString: URLString)
    }
}
