import UIKit
import Alamofire

class NetworkService {
    let token = "AQAAAAA5ir8sAAgNmHqe4K11l0sAgMFaf1ZvSzI"
    var HTTPHeaders: HTTPHeaders {
            return [
                "Accept": "application/json",
                "Authorization": "OAuth \(token)",
                "User-Agent": "skillbox x yandex app"
            ]
        }

    func request(urlString: String, with method: HTTPMethod, completion: @escaping (Result<Data, Error>) -> Void) {
        
        print("reqest - \(urlString)")
        
        guard let url = URL(string: urlString) else { return  }
        var request = URLRequest(url: url)
        
        request.method = method
        request.headers = HTTPHeaders
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let response = response else { return }
            print("Response from request - ", response)
            
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }.resume()
    }
}
