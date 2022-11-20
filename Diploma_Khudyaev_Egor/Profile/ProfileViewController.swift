import UIKit
import SnapKit
import Charts

final class ProfileViewController: UIViewController {
    
    let viewModel: ProfileViewModel
    //var pubFilesButton = UIButton()
    let containerView = UIView()
    let menu = Menu().menu

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        self.viewModel.getInfo()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var pieChart: PieChartView = {
        var totalDiskSpace: Double = Double((viewModel.dataModel?.totalSpace ?? 10) / 1073741824)
        var usedDiskSpace: Double = Double((viewModel.dataModel?.usedSpace ?? 1) / 1073741824)
        var freeDiskSpace: Double = totalDiskSpace - usedDiskSpace
        
        let pie = PieChartView()
        pie.isUserInteractionEnabled = false
        pie.centerText = "\(totalDiskSpace) Gb"
        pie.drawEntryLabelsEnabled = false
        
        pie.legend.horizontalAlignment = .center
        pie.legend.verticalAlignment = .bottom
        pie.legend.formToTextSpace = 12
        pie.legend.form = .circle
        pie.legend.formSize = 20
        pie.legend.font = UIFont.systemFont(ofSize: 14)

        var entries: [PieChartDataEntry] = []
        entries.append(PieChartDataEntry(value: Double(usedDiskSpace), label: Constants.Localization.used))
        entries.append(PieChartDataEntry(value: Double(freeDiskSpace), label: Constants.Localization.free))
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        let greyColor = NSUIColor(named: "Grey") ?? NSUIColor()
        let pinkColor = NSUIColor(named: "Pink") ?? NSUIColor()
        dataSet.colors = [pinkColor, greyColor]
        
        pie.data = PieChartData(dataSet: dataSet)
        
        return pie
    }()
    
    lazy var pubFilesButton: UIButton = {
        let button = UIButton(title: Constants.Localization.publishedFiles, target: self, selector: #selector(onOpenButton))
        button.titleLabel?.font = Constants.Font.textButton
        button.setTitleColor(UIColor(named: "Grey"), for: .normal)
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 5
        return button
    }()
    
    let screenSize = UIScreen.main.bounds
    var slideUpView = UITableView(frame: CGRect(x: 10, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 20, height: 250))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = Constants.Localization.profile
        
        tabBarController?.tabBar.isHidden = false
        
        let menuButton = UIBarButtonItem(title: ". . .", style: .plain, target: self, action: #selector(onMenuButton))
        navigationItem.rightBarButtonItem = menuButton
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3),                                   execute: {
            self.setupView()
        })
        
        slideUpView.isScrollEnabled = true
        slideUpView.delegate = self
        slideUpView.dataSource = self
    }
}

// MARK: - setup view

extension ProfileViewController {
    func setupView() {
        view.addSubview(pieChart)
        view.addSubview(pubFilesButton)
        
        pieChart.snp.makeConstraints { make in
            make.width.height.equalTo(300)
            make.center.equalTo(view.snp.center)
        }
        
        pubFilesButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(pieChart.snp.bottom).offset(100)
            make.width.equalTo(320)
            make.height.equalTo(50)
        }
    }
}

// MARK: - setup menu button

extension ProfileViewController {
    
    @objc
    private func onMenuButton() {
        //viewModel.openMenu()
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
    private func onOpenButton() {
        viewModel.openPublishedFilesScreen()
    }
}

// MARK: - little table for menu

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        case Constants.Localization.logout:
            cell.textLabel?.textColor = .red
        case Constants.Localization.cancel:
            cell.textLabel?.textColor = .blue
        default:
            cell.textLabel?.textColor = .lightGray
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
        case Constants.Localization.logout:
            self.viewModel.logOut()
            slideUpViewTapped()
        case Constants.Localization.cancel:
            slideUpViewTapped()
        default:
            break
        }
    }
    
    
}
