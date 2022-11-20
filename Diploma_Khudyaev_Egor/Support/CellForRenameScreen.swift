import UIKit
import SnapKit

class CellForRenameScreen: UITableViewCell {
    let cellIdentifier = "CellForRenameScreen"
    
    lazy var imageBlock: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemGray3
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var fileNameLabel: UITextField = {
        let field = UITextField()
        field.textAlignment = .left
        field.font = Constants.Font.textMain
        field.textColor = Constants.Colors.black
        field.contentMode = .scaleAspectFit
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var cancelImage: UIButton = {
        let cancel = UIButton(title: "", target: self, selector: #selector(onCancelButton))
        cancel.setImage(UIImage(named: "close"), for: .normal)
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.contentMode = .scaleAspectFit
        return cancel
    }()
    
    lazy var stackView: UIStackView = {
        let mainStack = UIStackView()
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .horizontal
        
        mainStack.addArrangedSubview(imageBlock)
        mainStack.addArrangedSubview(fileNameLabel)
        mainStack.addArrangedSubview(cancelImage)
        
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
    
    @objc
    private func onCancelButton() {
        fileNameLabel.text?.removeAll()
    }
    
    private func setupConstraints() {
        let scrrenSize = UIScreen.main.bounds
        
        stackView.snp.makeConstraints { make in
            make.left.equalTo(self.contentView.snp.left).inset(15)
            make.top.equalTo(self.contentView.snp.top).inset(15)
            make.right.equalTo(scrrenSize.width).inset(15)
            make.bottom.equalTo(self.contentView.snp.bottom).inset(15)
            
            //make.edges.equalTo(self.contentView).inset(16)
            make.height.equalTo(35)
        }
        
        imageBlock.snp.makeConstraints { make in
            make.left.equalTo(stackView.snp.left).offset(0)
            make.top.equalTo(stackView.snp.top).inset(5)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        fileNameLabel.snp.makeConstraints { make in
            make.left.equalTo(imageBlock.snp.right).offset(10)
            make.width.equalTo(200)
            make.centerY.equalTo(stackView.snp.centerY)
            //make.top.equalTo(self.contentView.snp.top).inset(10)
        }
    
        cancelImage.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.right.equalTo(stackView.snp.right).inset(5)
            make.top.equalTo(stackView.snp.top).inset(5)
            //make.centerY.equalTo(stackView.snp.centerY)
        }
    }
}
