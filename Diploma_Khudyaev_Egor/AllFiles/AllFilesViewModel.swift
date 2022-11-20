import Foundation
import UIKit

protocol AllFilesViewModelProtocol {
    
}

final class AllFilesViewModel: NSObject, AllFilesViewModelProtocol {
    typealias Route = FolderRoute & FileViewerRoute
    
    let networkDataFetcher = NetworkDataFetcher()
    private let router: Route
    var dataModel: [AllFilesModel]?

    init(router: Route) {
        self.router = router
    }
    
    func openFolderScreen(folderName: String) {
        router.openFolderScreen(folderName: folderName)
    }
    
    func openFileViewerScreen(_ file: String) {
        router.openFileViewerScreen(file)
    }
}

    
extension AllFilesViewModel {
    //MARK: - получить метаинформацию о файлах в папке
    
    func getMetaInfo(folderName: String) {
        let urlMetaString: String = "https://cloud-api.yandex.net/v1/disk/resources?path=/\(folderName)"
        networkDataFetcher.fetchDataAF(urlString: urlMetaString) { [self] (metaInfo) in
            dataModel = metaInfo
            print("data model count - ", self.dataModel?.count)
        }
    }
    
    func loadPreviewImage(to imageView: UIImageView, from URLString: String) {
        networkDataFetcher.asyncLoadImage(imageView, urlString: URLString)
    }
}














extension AllFilesViewModel {
//    func session() {
//        let urlString: String = "https://cloud-api.yandex.net/v1/disk"
//        let url = URL(string: urlString)
//        var request = URLRequest(url: url!)
//        request.method = .get
//        request.headers = HTTPHeaders
//        let session = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let response = response {
//                print(response)
//            }
//            if let error = error {
//                print("ERROR")
//                print(error.localizedDescription)
//            } else {
//                self.extractData(from: data)
//            }
//        }
//        session.resume()
//    }
//
//    func JSON(with data: Data?) -> [String: Any] {
//        var json = [String: Any]()
//        do {
//            try json = JSONSerialization.jsonObject(with: data ?? Data(), options: .allowFragments) as? Dictionary<String, Any> ?? [:]
//            //print(json)
//        } catch {
//            print(error.localizedDescription)
//        }
//        return json
//    }
//
//    func extractData(from jsonData: Data?) {
//        let json = self.JSON(with: jsonData)
//        if let array = json["system_folders"] as? [String: Any] {
//            for (key, value) in array {
//                allFilesViewModel.append(AllFilesModel(image: nil, imageURL: "", name: key, size: 0, date: Date(), hours: Date()))
//                //print("key - \(key), value - \(type(of: value))")
//            }
//        } else {
//            print("smtng wrng")
//        }
//    }
      
    //var parameters = [String: String]()
    
//    struct Parameter: Codable {
//        let name: String
//        let source: String
//    }
//
//    var HTTPHeaders: HTTPHeaders {
//        return [
//            "Accept": "application/json",
//            "Authorization": "OAuth \(token)",
//            "User-Agent": "skillbox x yandex app"
//        ]
//    }
}

extension AllFilesViewModel {
//    func createNewFolder() {
//        let urlString: String = "https://cloud-api.yandex.net/v1/disk/resources?path=new)"
//        let url = URL(string: urlString)
//        var request = URLRequest(url: url!)
//        request.method = .put
//        request.headers = HTTPHeaders
//        //request.addValue(<#T##value: String##String#>, forHTTPHeaderField: <#T##String#>)
//        let parameters: [String: Any] = ["new": "disk:/new"]
//
////        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
////        request.httpBody = httpBody
//
//        let session = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let response = response {
//                print(response)
//            }
//            guard let data = data else { return }
//            do {
//                let json = try? JSONSerialization.jsonObject(with: data)
//                print(json)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        session.resume()
//    }
}

//extension AllFilesViewModel {
//    func deleteItem(path: String) {
//        var urlString = "https://cloud-api.yandex.net/v1/disk/resources?path=\(path)"
//        let url = URL(string: urlString)
//        var request = URLRequest(url: url!)
//        request.method = .delete
//
//        let session = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let response = response {
//                print(response)
//            }
//            guard let data = data else { return }
//
//        }
//        session.jsonTaskWithMethod("DELETE", url: NSURL(string: url), onError: error) {
//            (jsonRoot, response)->Void in
//            switch response.statusCode {
//            case 202:
//                return handler(result: .InProcess(Disk.hrefMethodTemplatedWithDictionary(jsonRoot)))
//            case 204:
//                return handler(result: .Done)
//            default:
//                return error(NSError(...))
//            }
//        }.resume()
//    }
//}
