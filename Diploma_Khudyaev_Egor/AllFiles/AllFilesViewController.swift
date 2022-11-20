import UIKit
import SnapKit

protocol AllFilesViewControllerProtocol {
    
}

final class AllFilesViewController: UITableViewController {
    var viewModel: AllFilesViewModel?
    var folderName: String?

    init(viewModel: AllFilesViewModel, folderName: String) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.folderName = folderName
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var refreshController: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshTable), for: .allEvents)
        return refresh
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: self.view.center.y), size: CGSize(width: self.view.bounds.width - 16, height: 50.0)))
        messageLabel.center = self.view.center
        messageLabel.text = Constants.Localization.emptyDir
        messageLabel.numberOfLines = 0
        messageLabel.textColor = Constants.Colors.black
        messageLabel.textAlignment = .center;
        messageLabel.font = Constants.Font.textMain
        return messageLabel
    }()
    
    lazy var imageEmpyFolder: UIImageView = {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: self.view.bounds.width / 2 - 50, y: self.view.bounds.height / 2 - 150), size: CGSize(width: 100, height: 100)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "emptyDir")

        return imageView
    }()
    
    func showMessage() {
        self.view.addSubview(messageLabel)
        self.view.addSubview(imageEmpyFolder)
        self.view.bringSubviewToFront(messageLabel)
        self.view.bringSubviewToFront(imageEmpyFolder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tabBarController?.tabBar.isHidden = false
        
        if folderName != "" {
            navigationItem.title = titleNameBuilder(folderName)
        } else {
            navigationItem.title = Constants.Localization.allFiles
        }
        
        self.viewModel?.getMetaInfo(folderName: folderName ?? "")
        
        setupTableView()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3),
                                      execute: {
            self.tableView.reloadData()
            print("allFilesItems count = ", self.viewModel?.dataModel?.count)
        })
        
        view.addSubview(refreshController)
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(Cell.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc
    private func refreshTable() {
        self.tableView.reloadData()
        refreshController.endRefreshing()
    }
    
    func titleNameBuilder(_ name: String?) -> String? {
        let folderName = name?.removingPercentEncoding
        
        guard var folderName = folderName,
              let slashIndex = folderName.lastIndex(of: "/")
        else { return folderName }

        let index = folderName.index(after: slashIndex)
        let range = folderName.index(folderName.startIndex, offsetBy: 0)..<folderName.index(before: index)
        folderName.removeSubrange(range)
        folderName.remove(at: folderName.startIndex)
        
        print(folderName)
        
        return folderName
    }
}

    //MARK: - tableView function

extension AllFilesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.viewModel?.dataModel?.count == 0 {
            self.showMessage()
        }
        return self.viewModel?.dataModel?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") as? Cell,
              let item = self.viewModel?.dataModel?[indexPath.row],
              let urlString = item.file?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            return UITableViewCell()
        }

        if item.type == "dir" {
            cell.imageBlock.image = UIImage(named: "Folder")
        } else {
            self.viewModel?.loadPreviewImage(to: cell.imageBlock, from: urlString )
        }
        
        cell.fileNameLabel.text = item.name
        cell.fileInfoLabel.text = "20 Kb"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedRow = self.viewModel?.dataModel?[indexPath.row]
        
        switch selectedRow?.type {
        case "dir":
            let path = selectedRow?.path ?? ""

            self.viewModel?.openFolderScreen(folderName: URLAssistant.generatePathAndEncode(path))
        case "file":
            let path = selectedRow?.path ?? ""
            
            self.viewModel?.openFileViewerScreen(URLAssistant.generatePathAndEncode(path))
        default:
            break
        }
    }
}
