import UIKit

protocol Closable: AnyObject {
    func close()
}

protocol Routable: AnyObject {
    func route(to viewController: UIViewController, with transition: TransitionProtocol)
}

protocol RouterProtocol: Routable {
    var root: UIViewController? {get set}
}

class Router: NSObject, RouterProtocol, Closable {
    weak var root: UIViewController?
    private let rootTransition: TransitionProtocol
    
    init(rootTransition: TransitionProtocol) {
        self.rootTransition = rootTransition
    }
    
    func close() {
        guard let root = root else { return }
        rootTransition.close(root, completion: nil)
        
    }
    
    func route(to viewController: UIViewController, with transition: TransitionProtocol) {
        guard let root = root else { return }
        transition.open(viewController, from: root, completion: nil)
        //print("route to \(viewController)")
    }
}
