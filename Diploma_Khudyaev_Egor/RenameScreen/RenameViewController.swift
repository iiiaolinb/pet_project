import UIKit
import SnapKit

final class RenameViewController: UITableViewController, UITextFieldDelegate {
    var viewModel: RenameViewModel
    var file: FileViewerModel
    var newNameOfFile: String = ""

    init(viewModel: RenameViewModel, file: FileViewerModel) {
        self.viewModel = viewModel
        self.file = file
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = Constants.Localization.rename
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        setupTableView()
        setupNavigationBar()
    }
    
    @objc
    func backToFileViewer() {
        self.navigationController?.popViewController(animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.white]
    }
    
    @objc
    func backToFileViewerAndSave() {
        viewModel.close()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.white]

        let oldNameOfFile = file.name
        var path = file.path
        let baseURL = "https://cloud-api.yandex.net/v1/disk/resources/move?from="
        
        let oldNameCount = file.name.count
        let range1 = path.index(path.endIndex, offsetBy: -oldNameCount)..<path.endIndex
        let range2 = path.index(path.startIndex, offsetBy: 0)..<path.index(path.startIndex, offsetBy: 5)
        path.removeSubrange(range1)
        let newPath = path
        path.removeSubrange(range2)
        
        guard let encodePath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let encodeOldName = oldNameOfFile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let encodeNewName = newNameOfFile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        //print(baseURL + path + oldNameOfFile + "&path=" + path + newNameOfFile)
        
        viewModel.rename(urlString: baseURL + encodePath + encodeOldName + "&path=" + encodePath + encodeNewName)
        
        file.name = newNameOfFile
        file.path = newPath + newNameOfFile
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.black]
        navigationController?.navigationItem.title = Constants.Localization.rename
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrowBack"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backToFileViewer))
        
        let rightBarButtonItem = UIBarButtonItem(title: Constants.Localization.done,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(backToFileViewerAndSave))
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CellForRenameScreen.self, forCellReuseIdentifier: "CellForRenameScreen")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
}

    //MARK: - tableView function

extension RenameViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellForRenameScreen") as? CellForRenameScreen,
              let urlString = file.file?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            return UITableViewCell()
        }
        
        cell.fileNameLabel.text = file.name
        cell.fileNameLabel.delegate = self
        self.viewModel.loadPreviewImage(to: cell.imageBlock, from: urlString)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        newNameOfFile = textField.text ?? ""
        if textField.text != "" {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
//        print(newNameOfFile)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        textField.resignFirstResponder()
        return true
    }
}
