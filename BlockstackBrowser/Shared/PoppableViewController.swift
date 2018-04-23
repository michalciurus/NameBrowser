//  Created by Michal Ciurus

import UIKit
import SharedTools

/// Represents a view controller that can be popped from a navigation controller
class PoppableViewController: UIViewController {
    
    //MARK: Public Properties
    
    let willPop = EventObservable<Void>()
    
    //MARK: Public Methods
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParentViewController {
            willPop.fireEvent()
        }
    }
    
}
