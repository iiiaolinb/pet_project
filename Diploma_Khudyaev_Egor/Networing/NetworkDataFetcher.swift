import UIKit
import Alamofire
import ImageIO

class NetworkDataFetcher {
    //typealias FilesModel = PublishedFilesViewModelProtocol & LastFilesViewModelProtocol
    let networkService = NetworkService()
    
    //MARK: - datafetcher for All Files
    
    func fetchDataAF(urlString: String, closure: @escaping ([AllFilesModel]) -> Void) {
        networkService.request(urlString: urlString, with: .get) { (result) in
            switch result {
            case .success(let data):
                do {
                    let embedded = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    let items = embedded?["_embedded"] as? [String: Any]
                    let arrayData = items?["items"] as? [[String: Any]]
                    var finalData: [AllFilesModel] = []
                    
                    arrayData?.forEach({ data in
                        let path = data["path"] as? String ?? "no data"
                        let name = data["name"] as? String ?? "no data"
                        let type = data["type"] as? String ?? "no data"
                        let preview = data["preview"] as? String ?? Constants.Default.badConnection
                        let file = data["file"] as? String ?? "no data"
                        finalData.append(AllFilesModel(name: name, path: path, type: type, preview: preview, file: file))
                    })
                    closure(finalData ?? [AllFilesModel].init())
                    
                } catch let jsonError {
                    print("Error in JSON decoding", jsonError)
                    //closure(nil)
                }
            case .failure(let error):
                print("Error in request", error.localizedDescription)
                //closure(nil)
            }
        }
    }
    
    func resizeImage(at urlString: String, for size: CGSize) -> UIImage? {
        let file = urlString.removingPercentEncoding ?? Constants.Default.badConnection
        
        guard let url = URL(string: file),
              let data = try? Data(contentsOf: url)
        else {
            print("Problemss")
            return UIImage()
        }
        let image = UIImage(data: data) ?? UIImage()

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
                image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func asyncLoadImage(_ imageView: UIImageView, urlString: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let image = self.resizeImage(at: urlString, for: CGSize(width: 25, height: 25))

            DispatchQueue.main.sync {
                UIView.transition(with: imageView,
                                  duration: 1.0,
                                  options: [.curveEaseOut, .transitionCrossDissolve],
                                  animations: {
                                    imageView.image = image
                                })

            }
        }
    }
    
    func loadImage(_ string: String) -> UIImage {
        guard
            let url = URL(string: string),
            let data = try? Data(contentsOf: url)
        else {
            print("Не удалось загрузить изображение")
            let url = URL(string: Constants.Default.badConnection)
            let data = try? Data(contentsOf: url!)
            return UIImage(data: data!)!
        }
        return UIImage(data: data) ?? UIImage()
    }
}

    //MARK: - data fetcher for Published Files

extension NetworkDataFetcher {
    func fetchDataPF(urlString: String, closure: @escaping ([PublishedFilesModel]) -> Void) {
        networkService.request(urlString: urlString, with: .get) { (result) in
            switch result {
            case .success(let data):
                do {
                    let embedded = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    //let items = embedded?["_embedded"] as? [String: Any]
                    let arrayData = embedded?["items"] as? [[String: Any]]
                    var finalData: [PublishedFilesModel] = []
                    
                    arrayData?.forEach({ data in
                        let path = data["path"] as? String ?? "no data"
                        let name = data["name"] as? String ?? "no data"
                        let type = data["type"] as? String ?? "no data"
                        let preview = data["preview"] as? String ?? Constants.Default.badConnection
                        let file = data["file"] as? String ?? "no data"
                        finalData.append(PublishedFilesModel(name: name, path: path, type: type, preview: preview, file: file))
                        //print(name)
                    })
                    closure(finalData ?? [PublishedFilesModel].init())
                    
                } catch let jsonError {
                    print("Error in JSON decoding", jsonError)
                    //closure(nil)
                }
            case .failure(let error):
                print("Error in request", error.localizedDescription)
                //closure(nil)
            }
        }
    }
}

//MARK: - data fetcher for Last Files

extension NetworkDataFetcher {
    func fetchDataLF(urlString: String, closure: @escaping ([LastFilesModel]) -> Void) {
        networkService.request(urlString: urlString, with: .get) { (result) in
            switch result {
            case .success(let data):
                do {
                    let embedded = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    //let items = embedded?["_embedded"] as? [String: Any]
                    let arrayData = embedded?["items"] as? [[String: Any]]
                    var finalData: [LastFilesModel] = []
                    
                    arrayData?.forEach({ data in
                        let path = data["path"] as? String ?? "no data"
                        let name = data["name"] as? String ?? "no data"
                        let type = data["type"] as? String ?? "no data"
                        let preview = data["preview"] as? String ?? Constants.Default.badConnection
                        let file = data["file"] as? String ?? "no data"
                        finalData.append(LastFilesModel(name: name, path: path, type: type, preview: preview, file: file))
                        //print(name)
                    })
                    closure(finalData )
                    
                } catch let jsonError {
                    print("Error in JSON decoding", jsonError)
                    //closure(nil)
                }
            case .failure(let error):
                print("Error in request", error.localizedDescription)
                //closure(nil)
            }
        }
    }
}

    //MARK: - data fetcher for Profile (disk space)

extension NetworkDataFetcher {
    func fetchDataProfile(urlString: String, closure: @escaping (ProfileModel) -> Void) {
        networkService.request(urlString: urlString, with: .get) { (result) in
            switch result {
            case .success(let data):
                do {
                    let embedded = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    let totalSpace = embedded?["total_space"] as? Double ?? 1
                    let usedSpace = embedded?["used_space"] as? Double ?? 0
                    print("networkDF - \(totalSpace) \(usedSpace)")
                    let finalData: ProfileModel = ProfileModel(totalSpace: totalSpace, usedSpace: usedSpace)
                    
                    closure(finalData )
                    
                } catch let jsonError {
                    print("Error in JSON decoding", jsonError)
                    //closure(nil)
                }
            case .failure(let error):
                print("Error in request", error.localizedDescription)
                //closure(nil)
            }
        }
    }
}

//MARK: - datafetcher for FileViewer
extension NetworkDataFetcher {
    func fetchDataFV(urlString: String, closure: @escaping (FileViewerModel) -> Void) {
        networkService.request(urlString: urlString, with: .get) { (result) in
            switch result {
            case .success(let data):
                do {
                    let embedded = try JSONSerialization.jsonObject(with: data) as? [String: Any]

                    let finalData = FileViewerModel(name: embedded?["name"] as? String ?? "no data",
                                                    path: embedded?["path"] as? String ?? "no data",
                                                    type: embedded?["type"] as? String ?? "no data",
                                                    preview: embedded?["preview"] as? String ?? "no data",
                                                    file: embedded?["file"] as? String ?? "no data")
                    closure(finalData)
                    
                } catch let jsonError {
                    print("Error in JSON decoding", jsonError)
                    //closure(nil)
                }
            case .failure(let error):
                print("Error in request", error.localizedDescription)
                //closure(nil)
            }
        }
    }
}

    //MARK: - delete file/folder

extension NetworkDataFetcher {
    func delete(urlString: String) {
        networkService.request(urlString: urlString, with: .delete) { (result) in
            switch result {
            case .success(let data):
                print("File/folder already deleted \(data)")
            case .failure(let error):
                print("Error in request", error.localizedDescription)
                //closure(nil)
            }
        }
    }
}

    //MARK: - move/rename file

extension NetworkDataFetcher {
    func rename(urlString: String) {
        networkService.request(urlString: urlString, with: .post) { (result) in
            print("Data fetcher - \(urlString)")
            switch result {
            case .success(let data):
                print("File/folder has been renamed \(data)")
            case .failure(let error):
                print("Error in request", error.localizedDescription)
                //closure(nil)
            }
        }
    }
}
