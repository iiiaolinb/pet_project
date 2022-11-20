import UIKit

final class SampleVC: UIViewController {
    private let viewModel: SampleVM

    init(viewModel: SampleVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Sample"
        
        let dismissButton = UIButton(title: "Dismiss", target: self, selector: #selector(onDismissButton))
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc
    private func onDismissButton() {
        viewModel.dismiss()
    }
}



