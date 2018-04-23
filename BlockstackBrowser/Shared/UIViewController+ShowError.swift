//  Created by Michal Ciurus

import UIKit
import SharedTools

extension UIViewController {
    
    /// Subscribes to error events and shows them in UI
    ///
    /// - Parameter errorEmitter:
    func subscribeTo(errorEmitter: EmitsError) {
        errorEmitter.errorEvent.observe { [weak self] error in
            if let error = error {
                self?.view.showToast(text: error)
            }
        }
    }
    
}
