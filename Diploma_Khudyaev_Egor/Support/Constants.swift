import UIKit

enum Constants {
    enum Font {
        static var textHeader1 = UIFont(name: "Graphik", size: 24)
        static var textHeader2 = UIFont(name: "Graphik", size: 17)
        static var textMain = UIFont(name: "Graphik", size: 15)
        static var textSmall = UIFont(name: "Graphik", size: 13)
        static var textButton = UIFont(name: "Graphik", size: 16)
    }
    
    enum Colors {
        static let white = UIColor.white
        static let black = UIColor.black
        static let grey = UIColor(named: "Grey")
        static let pink = UIColor(named: "Pink")
        static let blue = UIColor(named: "Blue")
    }
    
    enum Localization {
        static let loginButton = Bundle.main.localizedString(forKey: "Login", value: "", table: "Localizable")
        static let loginTextField = Bundle.main.localizedString(forKey: "login", value: "", table: "Localizable")
        static let passwordTextFielf = Bundle.main.localizedString(forKey: "password", value: "", table: "Localizable")
        static let profile = Bundle.main.localizedString(forKey: "Profile", value: "", table: "Localizable")
        static let used = Bundle.main.localizedString(forKey: "Used", value: "", table: "Localizable")
        static let free = Bundle.main.localizedString(forKey: "Free", value: "", table: "Localizable")
        static let logout = Bundle.main.localizedString(forKey: "Logout", value: "", table: "Localizable")
        static let cancel = Bundle.main.localizedString(forKey: "Cancel", value: "", table: "Localizable")
        static let publishedFiles = Bundle.main.localizedString(forKey: "Published files", value: "", table: "Localizable")
        static let lastFiles = Bundle.main.localizedString(forKey: "Last files", value: "", table: "Localizable")
        static let allFiles = Bundle.main.localizedString(forKey: "All files", value: "", table: "Localizable")
        
        static let theImageWillBeDeleted = Bundle.main.localizedString(forKey: "The image will be deleted", value: "", table: "Localizable")
        static let delete = Bundle.main.localizedString(forKey: "Delete", value: "", table: "Localizable")
        static let share = Bundle.main.localizedString(forKey: "Share", value: "", table: "Localizable")
        static let file = Bundle.main.localizedString(forKey: "File", value: "", table: "Localizable")
        static let link = Bundle.main.localizedString(forKey: "Link", value: "", table: "Localizable")
        static let rename = Bundle.main.localizedString(forKey: "Rename", value: "", table: "Localizable")
        static let done = Bundle.main.localizedString(forKey: "Done", value: "", table: "Localizable")
        
        static let emptyDir = Bundle.main.localizedString(forKey: "The directory is empty", value: "", table: "Localizable")
        
    }
    
    enum Default {
        static let badConnection =  "https://storage.yandexcloud.net/printio/assets/realistic_views/round_mouse_pad/detailed/02c38a14fea7f3aea392ec09c2e32e955ad35361.jpg?1593264253"
    }
}
