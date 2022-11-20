import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    private let viewModel: LoginViewModel
    static var defaultsLogin = UserDefaults.standard

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var loginTextField: UITextField = {
        let login = UITextField()
        login.placeholder = Constants.Localization.loginTextField
        login.borderStyle = .roundedRect
        login.backgroundColor = UIColor(named: "Grey")
        return login
    }()
    
    lazy var passwordTextField: UITextField = {
        let password = UITextField()
        password.placeholder = Constants.Localization.passwordTextFielf
        password.borderStyle = .roundedRect
        password.backgroundColor = UIColor(named: "Grey")
        return password
    }()

    lazy var loginButton: UIButton = {
        let button = UIButton(title: Constants.Localization.loginButton, target: self, selector: #selector(onLoginButton))
        button.backgroundColor = Constants.Colors.blue
        button.titleLabel?.font = Constants.Font.textButton
        button.titleLabel?.textColor = Constants.Colors.white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupConstraints()
    }
    
    func setupConstraints() {
        self.view.addSubview(loginTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        
        loginTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).inset(60)
            make.width.equalTo(320)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.centerY).offset(60)
            make.width.equalTo(320)
            make.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(30)
            make.width.equalTo(320)
            make.height.equalTo(50)
        }
    }
    
    @objc private func onLoginButton() {

        if loginTextField.text == "" && passwordTextField.text == "" {
            incorrectData()
        } else {
            LoginViewController.defaultsLogin.set(loginTextField.text, forKey: Keys.defaultsName.rawValue)
            viewModel.openMainScreen()
        }
    }
    
    func incorrectData() {
        UIView.animateKeyframes(withDuration: 0.5,
                                delay: 0,
                                options: .calculationModeCubic,
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 1/5,
                               relativeDuration: 1/5) {
                self.loginTextField.transform = CGAffineTransform(translationX: 10, y: 0)
                self.loginTextField.backgroundColor = UIColor(named: "Pink")
                self.passwordTextField.transform = CGAffineTransform(translationX: 10, y: 0)
                self.passwordTextField.backgroundColor = UIColor(named: "Pink")
            }
            
            UIView.addKeyframe(withRelativeStartTime: 2/5,
                               relativeDuration: 1/5) {
                self.loginTextField.transform = CGAffineTransform(translationX: -10, y: 0)
                self.passwordTextField.transform = CGAffineTransform(translationX: -10, y: 0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 3/5,
                               relativeDuration: 1/5) {
                self.loginTextField.transform = CGAffineTransform(translationX: 10, y: 0)
                self.passwordTextField.transform = CGAffineTransform(translationX: 10, y: 0)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 4/5,
                               relativeDuration: 1/5) {
                self.loginTextField.transform = CGAffineTransform(translationX: -10, y: 0)
                self.passwordTextField.transform = CGAffineTransform(translationX: -10, y: 0)
            }
            
        },
                                completion: { _ in
            self.loginTextField.transform = .identity
            self.loginTextField.backgroundColor = Constants.Colors.grey
            self.passwordTextField.transform = .identity
            self.passwordTextField.backgroundColor = Constants.Colors.grey
        })
    }
}

