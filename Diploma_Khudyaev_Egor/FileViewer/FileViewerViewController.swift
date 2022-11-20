import UIKit
import SnapKit

final class FileViewerViewController: UIViewController {
    private let viewModel: FileViewerViewModel
    let containerView = UIView()
    var menu = [[String]]()
    
    let screenSize = UIScreen.main.bounds
    var slideUpView = UITableView(frame: CGRect(x: 10, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 20, height: 250))

    init(viewModel: FileViewerViewModel, folderName: String) {
        self.viewModel = viewModel
        viewModel.getMetaInfo(folderName: folderName)
        //print(self.file)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        
        let image = viewModel.loadImage(fromURL: viewModel.dataModel?.file ?? Constants.Default.badConnection)
        imageView.image = image
        
        return imageView
    }()
    
    lazy var message: UILabel = {
        let label = UILabel(frame: CGRect(x: screenSize.width / 2 - 100, y: screenSize.height / 2 - 75, width: 200, height: 150))
        label.backgroundColor = Constants.Colors.grey
        label.textColor = Constants.Colors.black
        label.font = Constants.Font.textSmall
        label.clipsToBounds = true
        label.layer.cornerRadius = 15
        label.alpha = 0
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "The link is copied to memory"
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton(title: "", target: self, selector: #selector(onShareButton))
        button.setImage(UIImage(named: "shareIt"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    lazy var trashButton: UIButton = {
        let button = UIButton(title: "", target: self, selector: #selector(onTrashButton))
        button.setImage(UIImage(named: "trashIt"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = viewModel.dataModel?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = viewModel.dataModel?.name
        
        setupPreview()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3),
                                      execute: {
            self.setupImageView()
            self.setupNavigationBar()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        })
        
        slideUpView.isScrollEnabled = true
        slideUpView.delegate = self
        slideUpView.dataSource = self
    }
    
    func displayAMassage() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .showHideTransitionViews,
                       animations: {
            //self.view.addSubview(self.message)
            self.message.alpha = 0.8
        },
                       completion: { _ in
            sleep(1)
            self.message.alpha = 0
            //self.message.removeFromSuperview()
        })
    }
}

    //MARK: - setup view

extension FileViewerViewController {
    func setupPreview() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
        }
        activityIndicator.startAnimating()
    }
    
    func setupImageView() {
        let screenSize = UIScreen.main.bounds.size
        
        view.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).offset(15)
            make.bottom.equalTo(view.snp.bottom).inset(15)
            make.width.height.equalTo(50)
        }
        
        view.addSubview(trashButton)
        trashButton.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).inset(15)
            make.bottom.equalTo(view.snp.bottom).inset(15)
            make.width.height.equalTo(50)
        }
        
        view.addSubview(self.message)
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.white]
        navigationItem.title = viewModel.dataModel?.name
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrowBack"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backToAllFiles))
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "editIt"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(onEditButton))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.leftBarButtonItem?.tintColor = Constants.Colors.grey
        navigationItem.rightBarButtonItem?.tintColor = Constants.Colors.grey
        tabBarController?.tabBar.isHidden = true
    }
}

    //MARK: - buttons function

extension FileViewerViewController {
    @objc
    func backToAllFiles() {
        self.navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.Colors.black]
    }
    
    @objc
    func onShareButton() {
        menu = ViewerMenu().menuShare
        
        self.slideUpView.reloadData()
        
        let window = self.view.window
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        containerView.frame = self.view.frame
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(slideUpViewTapped))
        containerView.addGestureRecognizer(tapGesture)
        
        containerView.alpha = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.containerView.alpha = 0.8
            self.slideUpView.backgroundColor = .clear
            self.slideUpView.frame = CGRect(x: 10, y: self.screenSize.height - 300, width: self.screenSize.width - 20, height: 300)
        },
                       completion: nil)
          
        window?.addSubview(containerView)
        window?.addSubview(slideUpView)
    }
    
    @objc
    func onTrashButton() {
        menu = ViewerMenu().menuDelete
        
        self.slideUpView.reloadData()
        
        let window = self.view.window
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        containerView.frame = self.view.frame
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(slideUpViewTapped))
        containerView.addGestureRecognizer(tapGesture)
        
        containerView.alpha = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.containerView.alpha = 0.8
            self.slideUpView.backgroundColor = .clear
            self.slideUpView.frame = CGRect(x: 10, y: self.screenSize.height - 250, width: self.screenSize.width - 20, height: 250)
        },
                       completion: nil)
          
        window?.addSubview(containerView)
        window?.addSubview(slideUpView)
    }
    
    @objc
    private func slideUpViewTapped() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.1,
                       options: .curveEaseInOut,
                       animations: {
            self.containerView.alpha = 0
            self.slideUpView.frame = CGRect(x: 10, y: self.screenSize.height, width: self.screenSize.width - 20, height: 250)
        },
                       completion: nil)
    }
    
    @objc
    private func onEditButton() {
        guard let file = viewModel.dataModel else { return }
        viewModel.openRenameScreen(file)
    }
}

// MARK: - little table for menu

extension FileViewerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        lazy var cell: UITableViewCell = {
            let cell = UITableViewCell()
            cell.layer.cornerRadius = 15
            cell.clipsToBounds = true
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .lightGray
            return cell
        }()
        let section = menu[indexPath.section][indexPath.item]
        cell.textLabel?.text = section
        switch section {
        case Constants.Localization.share:
            cell.textLabel?.textColor = .lightGray
        case Constants.Localization.theImageWillBeDeleted:
            cell.textLabel?.textColor = .lightGray
        case Constants.Localization.delete:
            cell.textLabel?.textColor = .red
        case Constants.Localization.cancel:
            cell.textLabel?.textColor = .blue
        default:
            cell.textLabel?.textColor = Constants.Colors.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "  "
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        switch cell?.textLabel?.text {
        case Constants.Localization.delete:
            guard let file = viewModel.dataModel?.path else {
                slideUpViewTapped()
                return
            }
            
            self.viewModel.delete(urlString: file)
            slideUpViewTapped()
            self.navigationController?.popViewController(animated: true)
        case Constants.Localization.link:
            displayAMassage()
            slideUpViewTapped()
        case Constants.Localization.file:
            displayAMassage()
            slideUpViewTapped()
        case Constants.Localization.cancel:
            slideUpViewTapped()
        default:
            break
        }
    }
    
    
}


