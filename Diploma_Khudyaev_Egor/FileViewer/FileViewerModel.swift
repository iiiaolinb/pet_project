class FileViewerModel {
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
}


struct ViewerMenu {
    
    let menuDelete: [[String]] = [[Constants.Localization.theImageWillBeDeleted, Constants.Localization.delete], [Constants.Localization.cancel]]
    
    let menuShare: [[String]] = [[Constants.Localization.share, Constants.Localization.file, Constants.Localization.link], [Constants.Localization.cancel]]
}
