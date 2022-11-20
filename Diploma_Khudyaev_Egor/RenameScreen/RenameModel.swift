class RenameModel {
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
