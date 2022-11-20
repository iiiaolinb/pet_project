import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    var swipeDetection: Int = 0
    let textForTextLabel = ["Теперь все ваши документы в одном месте",
                            "Доступ к файлам без интернета",
                            "Делитесь вашими файлами с другими"]
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "Onboarding\(swipeDetection)")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var textLabel: UILabel = {
        let text = UILabel()
        text.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        text.textAlignment = .center
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        text.text = self.textForTextLabel[0]
        return text
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 30
        return stack
    }()
    
    lazy var placeForDot1: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "DotBlue")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tag = 0
        return imageView
    }()
    
    lazy var placeForDot2: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "DotGray")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tag = 1
        return imageView
    }()
    
    lazy var placeForDot3: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "DotGray")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tag = 2
        return imageView
    }()
    
    lazy var stackWithDots: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 15
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        view.addGestureRecognizer(createGestureRecognizer(for: .left))
        view.addGestureRecognizer(createGestureRecognizer(for: .right))
    }
    
    func setupView() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        view.addSubview(stackView)
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(stackView.snp.centerX)
            make.top.equalTo(stackView.snp.top)
            make.width.equalTo(200)
        }
        
        textLabel.snp.makeConstraints { make in
            make.centerX.equalTo(stackView.snp.centerX)
            make.bottom.equalTo(stackView.snp.bottom)
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(view.center)
        }
        
        view.addSubview(stackWithDots)
        stackWithDots.addArrangedSubview(placeForDot1)
        stackWithDots.addArrangedSubview(placeForDot2)
        stackWithDots.addArrangedSubview(placeForDot3)
        
        placeForDot1.snp.makeConstraints { make in
            make.width.height.equalTo(10)
        }
        
        placeForDot2.snp.makeConstraints { make in
            make.width.height.equalTo(10)
        }
        
        placeForDot3.snp.makeConstraints { make in
            make.width.height.equalTo(10)
        }
        
        stackWithDots.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
        }
    }
    
    func createGestureRecognizer(for direction: UISwipeGestureRecognizer.Direction) -> UISwipeGestureRecognizer {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_ :)))
        swipe.direction = direction
        return swipe
    }
    
    func swipeAnimation() {
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: .curveLinear) {
            self.imageView.image = UIImage(named: "Onboarding\(self.swipeDetection)")
            self.textLabel.text = self.textForTextLabel[self.swipeDetection]
            let dots = [self.placeForDot1, self.placeForDot2, self.placeForDot3]
            for dot in dots {
                if dot.tag == self.swipeDetection {
                    dot.image = UIImage(named: "DotBlue")
                } else {
                    dot.image = UIImage(named: "DotGray")
                }
            }
        }
    }
    
    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            if self.swipeDetection < 2 {
                self.swipeDetection += 1
                swipeAnimation()
            }
        case .right:
            if self.swipeDetection > 0 {
                self.swipeDetection -= 1
                swipeAnimation()
            }
        case .down:
            break
        case .up:
            break
        default:
            break
        }
    }
}
