import UIKit

class URLAssistant {
    
    static func generateURLForRename(_ fileName: AllFilesModel, newName: String) -> String {
        let baseURLForRename = "https://cloud-api.yandex.net/v1/disk/resources/move?from="
        
        let oldNameOfFile = fileName.name
        var path = fileName.path
        let oldNameCount = fileName.name.count
        let range1 = path.index(path.endIndex, offsetBy: -oldNameCount)..<path.endIndex
        let range2 = path.index(path.startIndex, offsetBy: 0)..<path.index(path.startIndex, offsetBy: 5)
        path.removeSubrange(range1)
        path.removeSubrange(range2)
        
        print(path)
        //let newPath = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? path
        
        let URLString: String = baseURLForRename + path + oldNameOfFile + "&path" + path + newName
        
        return URLString
    }
    
    static func generateNewpath(_ fileName: AllFilesModel, newName: String) -> String {
        var path = fileName.path
        let oldNameCount = fileName.name.count
        let range = path.index(path.endIndex, offsetBy: -oldNameCount)..<path.endIndex
        path.removeSubrange(range)
        
        return path + newName
    }
    
    static func generatePathAndEncode(_ path: String) -> String {
        var path = path
        let range = path.index(path.startIndex, offsetBy: 0)..<path.index(path.startIndex, offsetBy: 6)
        path.removeSubrange(range)
        
        guard let encodeName = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("String encoding error")
            return ""
        }
        
        return encodeName
    }
}
