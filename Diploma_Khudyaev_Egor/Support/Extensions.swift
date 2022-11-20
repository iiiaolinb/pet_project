import UIKit

extension UIButton {
    convenience init(title: String, target: Any, selector: Selector) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        addTarget(target, action: selector, for: .touchUpInside)
    }
}

extension UITableView {
    func setupEmptyTableView() {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
                messageLabel.text = "The dir is empty"
                messageLabel.textColor = .black
                messageLabel.numberOfLines = 0
                messageLabel.textAlignment = .center
                //messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
                messageLabel.sizeToFit()

                self.backgroundView = messageLabel
                self.separatorStyle = .none
    }
}
