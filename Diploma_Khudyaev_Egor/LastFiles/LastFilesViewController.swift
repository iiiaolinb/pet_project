import UIKit

final class LastFilesViewController: UITableViewController {
    private let viewModel: LastFilesViewModel?
    
    lazy var refreshController: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshTable), for: .allEvents)
        return refresh
    }()

    init(viewModel: LastFilesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = Constants.Localization.lastFiles
        
        tabBarController?.tabBar.isHidden = false
        
        self.viewModel?.getInfo()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(Cell.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.delegate = self
        tableView.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3),
                                      execute: {
            self.tableView.reloadData()
        })
        
        view.addSubview(refreshController)
    }
    
    @objc
    private func refreshTable() {
        self.tableView.reloadData()
        refreshController.endRefreshing()
    }
}

    // MARK: - tableView function

extension LastFilesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel?.dataModel?.count ?? 1
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
            self.viewModel?.loadPreviewImage(to: cell.imageBlock, from: urlString)
        }
        
        cell.fileNameLabel.text = item.name

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
            let folderName = selectedRow?.name ?? ""
            
            guard let encodeFolderName = folderName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print("String encoding error")
                return
            }
            
            self.viewModel?.openFolderScreen(encodeFolderName)
        case "file":
            var fileNamePath = selectedRow?.path ?? ""
            
            let range = fileNamePath.index(fileNamePath.startIndex, offsetBy: 0)..<fileNamePath.index(fileNamePath.startIndex, offsetBy: 6)
            fileNamePath.removeSubrange(range)
            
            guard let encodeFileNamePath = fileNamePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            else {
                print("String encoding error")
                return
            }
            print("File name path - \(encodeFileNamePath)")
            self.viewModel?.openFileViewerScreen(encodeFileNamePath)
        default:
            break
        }
    }
}
