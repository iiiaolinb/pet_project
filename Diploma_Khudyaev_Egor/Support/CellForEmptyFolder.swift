import UIKit
import SnapKit

class CellForEmptyFolder: UITableViewCell {
    let cellIdentifier = "CellForEmptyFolder"
    
    lazy var imageV: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "emptyDir")
        return image
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.Localization.emptyDir
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(imageV)
        stack.addArrangedSubview(label)
        
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    func setupConstraints() {
        guard let view = UIWindow().rootViewController?.view else {return}

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
        
        imageV.snp.makeConstraints { make in
            make.center.equalTo(stackView.snp.center)
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(imageV.snp.centerX)
            make.top.equalTo(imageV.snp.bottom).inset(20)
        }
    }
}
