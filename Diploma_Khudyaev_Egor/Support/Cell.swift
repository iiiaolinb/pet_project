import UIKit
import SnapKit

class Cell: UITableViewCell {
    let cellIdentifier = "cellIdentifier"
    
    lazy var imageBlock: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemGray3
        return image
    }()
    
    lazy var fileNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Constants.Font.textMain
        label.textColor = Constants.Colors.black
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var fileInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Constants.Font.textSmall
        label.textColor = Constants.Colors.grey
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let mainStack = UIStackView()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .horizontal
        
        let rightStack = UIStackView()
        rightStack.axis = .vertical
        
        rightStack.addArrangedSubview(fileNameLabel)
        rightStack.addArrangedSubview(fileInfoLabel)
        
        mainStack.addArrangedSubview(imageBlock)
        mainStack.addArrangedSubview(rightStack)
        
        return mainStack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView).inset(16)
        }
        
        imageBlock.snp.makeConstraints { make in
            make.left.equalTo(stackView.snp_leftMargin).offset(0)
            make.top.equalTo(stackView.snp_topMargin).offset(5)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        fileNameLabel.snp.makeConstraints { make in
            make.left.equalTo(stackView.snp.left).offset(40)
            make.top.equalTo(self.contentView.snp.top).inset(10)
        }
        
        fileInfoLabel.snp.makeConstraints { make in
            make.left.equalTo(stackView.snp.left).offset(40)
            make.bottom.equalTo(self.contentView.snp.bottom).inset(10)
        }
    }
}
