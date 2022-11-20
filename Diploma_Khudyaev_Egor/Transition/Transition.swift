import UIKit

protocol TransitionProtocol {
    func open(_ viewController: UIViewController, from: UIViewController, completion: (() -> Void)?)
    func close(_ viewController: UIViewController, completion: (() -> Void)?)
}

class Transition: TransitionProtocol {
    func open(_ viewController: UIViewController, from: UIViewController, completion: (() -> Void)?) {
    }
    
    func close(_ viewController: UIViewController, completion: (() -> Void)?) {
    }
}
