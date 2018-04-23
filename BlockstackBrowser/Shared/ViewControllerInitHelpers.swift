//  Created by Michal Ciurus

import UIKit

extension UIStoryboard {
    
    enum Storyboard: String {
        case namesList = "NamesList"
    }
    
    convenience init(_ storyboard: Storyboard) {
        self.init(name: storyboard.rawValue, bundle: nil)
    }
    
}

protocol Identifiable {
    
    static var identifier: String { get }
    
}

extension Identifiable {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension Identifiable where Self: UIViewController {
    
    static func instantiate(from storyboard: UIStoryboard) -> Self {
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self
        guard let instantiatedVc = viewController else { fatalError("Can't instantiate ViewController") }
        return instantiatedVc
    }
    
}
