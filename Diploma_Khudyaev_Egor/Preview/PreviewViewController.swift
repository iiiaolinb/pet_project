import UIKit
import SnapKit

class PreviewViewController: UIViewController {
    private let viewModel: PreviewViewModel

    init(viewModel: PreviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var launchImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "Launch")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowOpacity = 5
        imageView.layer.shadowOffset = CGSize(width: 10, height: 0)
        imageView.alpha = 0.3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var launchLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0.3
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 5
        label.layer.shadowOffset = CGSize(width: 10, height: 0)
        label.text = "Diploma"
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 30
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var shadowRightBlueView: UIView = {
        let view = UIView(frame: view.bounds)
        let layer = CAGradientLayer()
        layer.frame = self.view.bounds
        layer.colors = [UIColor.clear.cgColor, UIColor(named: "Blue")?.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(layer)
        view.alpha = 1
        return view
    }()
    
    lazy var shadowLeftBlueView: UIView = {
        let view = UIView(frame: view.bounds)
        let layer = CAGradientLayer()
        layer.frame = self.view.bounds
        layer.colors = [UIColor.clear.cgColor, UIColor(named: "Blue")?.cgColor]
        layer.startPoint = CGPoint(x: 1, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        view.layer.addSublayer(layer)
        view.alpha = 0
        return view
    }()
    
    lazy var shadowLeftPinkView: UIView = {
        let view = UIView(frame: view.bounds)
        view.alpha = 1.0
        //view.backgroundColor = UIColor(named: "Pink")
        let layer = CAGradientLayer()
        layer.frame = self.view.bounds
        layer.colors = [UIColor(named: "Pink")?.cgColor, UIColor.clear.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(layer)
        return view
    }()
    
    lazy var shadowRightPinkView: UIView = {
        let view = UIView(frame: view.bounds)
        view.alpha = 0.0
        //view.backgroundColor = UIColor(named: "Pink")
        let layer = CAGradientLayer()
        layer.frame = self.view.bounds
        layer.colors = [UIColor(named: "Pink")?.cgColor, UIColor.clear.cgColor]
        layer.startPoint = CGPoint(x: 1, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        view.layer.addSublayer(layer)
        return view
    }()
    
    let button: UIButton = {
        let button = UIButton(title: Constants.Localization.loginButton, target: self, selector: #selector(onButton))
        button.backgroundColor = Constants.Colors.blue
        button.titleLabel?.textColor = Constants.Colors.white
        button.titleLabel?.font = Constants.Font.textButton
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.alpha = 0
        return button
    }()
    
    @objc func onButton() {
        viewModel.openLoginScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
        rightShadow()
    }
    
    func addSubviews() {
        view.addSubview(shadowRightBlueView)
        view.addSubview(shadowLeftBlueView)
        view.addSubview(shadowLeftPinkView)
        view.addSubview(shadowRightPinkView)
        view.addSubview(stackView)
        view.addSubview(button)
    }
    
    func setupConstraints() {
        stackView.addArrangedSubview(launchImage)
        stackView.addArrangedSubview(launchLabel)
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(self.view.snp.center)
            make.width.equalTo(200)
        }
        
        launchImage.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerX.equalTo(stackView.snp.centerX)
            make.top.equalTo(stackView.snp.top)
        }
        
        launchLabel.snp.makeConstraints { make in
            make.centerX.equalTo(stackView.snp.centerX)
            make.bottom.equalTo(stackView.snp.bottom)
        }
        
        button.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(30)
            make.width.equalTo(320)
            make.height.equalTo(50)
        }
    }
    
    enum segment {
            case x
            case y
            case h
        }
        
        func calcTrig(segment: segment, size: CGFloat, angle: CGFloat) -> [segment : CGFloat] {
            switch segment {
                case .x:
                    let x = size
                    let y = tan(angle * .pi/180) * x
                    let h = x / cos(angle * .pi/180)
                    return [ .x : x, .y : y, .h : h]
                case .y:
                    let y = size
                    let x = y / tan(angle * .pi/180)
                    let h = y / sin(angle * .pi/180)
                    return [ .x : x, .y : y, .h : h]
                case .h:
                    let h = size
                    let x = cos(angle * .pi/180) * h
                    let y = sin(angle * .pi/180) * h
                    return [ .x : x, .y : y, .h : h]
            }
        }
    
    func rightShadow() {
       UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn) {
           self.shadowLeftPinkView.alpha = 0.9
           self.shadowRightPinkView.alpha = 0.1
           self.shadowLeftBlueView.alpha = 0.1
           self.shadowRightBlueView.alpha = 0.9
           self.launchLabel.alpha = 0.7
           self.launchImage.alpha = 0.7
       } completion: { success in
           self.rightHalfBottomShadow()
       }
    }
    
    func rightHalfBottomShadow() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
            let trig = self.calcTrig(segment: .h, size: 10, angle: 22.5)
            let x = trig[.x]
            let y = trig[.y]
            self.launchLabel.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.launchImage.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.shadowLeftPinkView.alpha = 0.7
            self.shadowRightPinkView.alpha = 0.2
            self.shadowLeftBlueView.alpha = 0.2
            self.shadowRightBlueView.alpha = 0.7
            self.launchLabel.alpha = 1
            self.launchImage.alpha = 1
        } completion: { success in
            self.rightBottomShadow()
        }
    }
        
    func rightBottomShadow() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
            let trig = self.calcTrig(segment: .h, size: 10, angle: 45)
            let x = trig[.x]
            let y = trig[.y]
            self.launchLabel.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.launchImage.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.shadowLeftPinkView.alpha = 0.6
            self.shadowRightPinkView.alpha = 0.5
            self.shadowLeftBlueView.alpha = 0.5
            self.shadowRightBlueView.alpha = 0.6
            self.launchLabel.alpha = 0.7
            self.launchImage.alpha = 0.7
        } completion: { success in
            self.halfRightBottomShadow()
        }
    }
        
    func halfRightBottomShadow() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
            let trig = self.calcTrig(segment: .h, size: 10, angle: 67.5)
            let x = trig[.x]
            let y = trig[.y]
            self.launchLabel.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.launchImage.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.shadowLeftPinkView.alpha = 0.5
            self.shadowRightPinkView.alpha = 0.7
            self.shadowLeftBlueView.alpha = 0.7
            self.shadowRightBlueView.alpha = 0.5
            self.launchLabel.alpha = 0.6
            self.launchImage.alpha = 0.6
        } completion: { success in
            self.bottomShadow()
        }
    }
        
    func bottomShadow() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
            let trig = self.calcTrig(segment: .h, size: 10, angle: 90)
            let x = trig[.x]
            let y = trig[.y]
            self.launchLabel.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.launchImage.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.shadowLeftPinkView.alpha = 0.4
            self.shadowRightPinkView.alpha = 0.9
            self.shadowLeftBlueView.alpha = 0.9
            self.shadowRightBlueView.alpha = 0.4
            self.launchLabel.alpha = 0.9
            self.launchImage.alpha = 0.9
        } completion: { success in
            self.halfLeftBottomShadow()
        }
    }
        
    func halfLeftBottomShadow() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
            let trig = self.calcTrig(segment: .h, size: 10, angle: 112.5)
            let x = trig[.x]
            let y = trig[.y]
            self.launchLabel.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.launchImage.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.shadowLeftPinkView.alpha = 0.3
            self.shadowRightPinkView.alpha = 1
            self.shadowLeftBlueView.alpha = 1
            self.shadowRightBlueView.alpha = 0.3
            self.launchLabel.alpha = 1
            self.launchImage.alpha = 1
        } completion: { success in
            self.leftBottomShadow()
        }
    }
        
    func leftBottomShadow() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            let trig = self.calcTrig(segment: .h, size: 10, angle: 135)
            let x = trig[.x]
            let y = trig[.y]
            self.launchLabel.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.launchImage.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.shadowLeftPinkView.alpha = 0.2
            self.shadowRightPinkView.alpha = 0.8
            self.shadowLeftBlueView.alpha = 0.8
            self.shadowRightBlueView.alpha = 0.2
            self.launchLabel.alpha = 0.7
            self.launchImage.alpha = 0.7
            self.launchLabel.layer.shadowOpacity = 2
            self.launchImage.layer.shadowOpacity = 2
        } completion: { success in
            self.halfTopShadow()
        }
    }
    
    func halfTopShadow() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            let trig = self.calcTrig(segment: .h, size: 10, angle: 157.5)
            let x = trig[.x]
            let y = trig[.y]
            self.launchLabel.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.launchImage.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.shadowLeftPinkView.alpha = 0.1
            self.shadowRightPinkView.alpha = 0.5
            self.shadowLeftBlueView.alpha = 0.5
            self.shadowRightBlueView.alpha = 0.1
            self.launchLabel.alpha = 0.9
            self.launchImage.alpha = 0.9
            self.launchLabel.layer.shadowOpacity = 1
            self.launchImage.layer.shadowOpacity = 1
        } completion: { success in
            self.topShadow()
        }
    }
    
    func topShadow() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            let trig = self.calcTrig(segment: .h, size: 10, angle: 180)
            let x = trig[.x]
            let y = trig[.y]
            self.launchLabel.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.launchImage.layer.shadowOffset = CGSize(width: x!, height: y!)
            self.shadowLeftPinkView.alpha = 0.0
            self.shadowRightPinkView.alpha = 0.0
            self.shadowLeftBlueView.alpha = 0.0
            self.shadowRightBlueView.alpha = 0.0
            self.launchLabel.alpha = 1
            self.launchImage.alpha = 1
            self.launchLabel.layer.shadowOpacity = 0
            self.launchImage.layer.shadowOpacity = 0
        } completion: { success in
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")
//            self.present(vc, animated: true, completion: nil)
            
            if self.viewModel.isPresent() {
                let vc = OnboardingViewController()
                self.present(vc, animated: true)
                PreviewViewModel.defaults.set(true, forKey: Keys.isPresent.rawValue)
            }
            
            self.button.alpha = 1
            self.shadowLeftBlueView.removeFromSuperview()
            self.shadowLeftPinkView.removeFromSuperview()
            self.shadowRightBlueView.removeFromSuperview()
            self.shadowRightPinkView.removeFromSuperview()
        }
    }
}

