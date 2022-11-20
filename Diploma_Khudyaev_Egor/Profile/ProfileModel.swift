import UIKit

enum ProfileKey {
    static let key = "key"
}

//struct AllFilesModel: Codable {
//    //let systemFoders: [String: String]
//    var items: [Items]
//
////    enum CodingKeys: String, CodingKeys {
////        case embedded = "_embedded"
////    }
//}
//
//struct Items: Codable {
//    let path: String
//    let name: String
//    let type: String
//    let preview: String?
//}

final class ProfileModel: NSObject, NSCoding {
    var totalSpace: Double
    var usedSpace: Double
    
    init(totalSpace: Double, usedSpace: Double) {
        self.totalSpace = totalSpace
        self.usedSpace = usedSpace
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(totalSpace, forKey: "totalSpace")
        coder.encode(usedSpace, forKey: "usedSpace")
    }
    
    init?(coder: NSCoder) {
        totalSpace = coder.decodeObject(forKey: "totalSpace") as? Double ?? 0
        usedSpace = coder.decodeObject(forKey: "usedSpace") as? Double ?? 0
    }
}

final class PModel {
    static var item: ProfileModel! {
        get {
            guard let savedData = UserDefaults.standard.object(forKey: Keys.itemProfile.rawValue) as? Data,
                  let decodedModel = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ProfileModel.self, from: savedData) else { return nil }
            return decodedModel
        }
        
        set {
            let defaults = UserDefaults.standard
            let key = Keys.itemProfile.rawValue
            if let model = newValue {
                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false) {
                    defaults.set(savedData, forKey: key)
                }
            }
        }
    }
}

