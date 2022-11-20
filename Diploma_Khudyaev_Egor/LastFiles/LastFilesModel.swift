import UIKit

protocol LastFilesModelProtocol {
    var name: String {get set}
    var path: String {get set}
    var type: String {get set}
    var preview: String {get set}
    var file: String {get set}
}

enum LFKey {
    static let key = "key"
}

final class LastFilesModel: NSObject, NSCoding, LastFilesViewModelProtocol {
    var name: String
    var path: String
    var type: String
    var preview: String?
    var file: String?
    
    init(name: String, path: String, type: String, preview: String?, file: String?) {
        self.name = name
        self.path = path
        self.type = type
        self.preview = preview
        self.file = file
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(path, forKey: "path")
        coder.encode(type, forKey: "type")
        coder.encode(preview, forKey: "preview")
        coder.encode(file, forKey: "file")
    }
    
    init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        path = coder.decodeObject(forKey: "path") as? String ?? ""
        type = coder.decodeObject(forKey: "type") as? String ?? ""
        preview = coder.decodeObject(forKey: "preview") as? String ?? ""
        file = coder.decodeObject(forKey: "file") as? String ?? ""
    }
}

final class LFModel {
    static var item: LastFilesModel! {
        get {
            guard let savedData = UserDefaults.standard.object(forKey: Keys.itemLastFiles.rawValue) as? Data,
                  let decodedModel = try? NSKeyedUnarchiver.unarchivedObject(ofClass: LastFilesModel.self, from: savedData) else { return nil }
            return decodedModel
        }
        
        set {
            let defaults = UserDefaults.standard
            let key = Keys.itemLastFiles.rawValue
            if let model = newValue {
                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false) {
                    defaults.set(savedData, forKey: key)
                }
            }
        }
    }
}

