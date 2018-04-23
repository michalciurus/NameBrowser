//  Created by Michal Ciurus
import UIKit

struct ToastConstants {
    static let seconds = 3
}

extension UIView {
    
    typealias C = ToastConstants
    
    @objc func showToast(text: String) {
        let toastView = getToastView()
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.label.text = text
        toastView.alpha = 0
        
        show(seconds: C.seconds, view: toastView)
        toastView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        toastView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        toastView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        toastView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
    }
    
    private func getToastView() -> ToastView {
        
        for subview in subviews {
            if let toastSubview = subview as? ToastView {
                return toastSubview
            }
        }
        
        guard let toastView = Bundle.main.loadNibNamed(ToastView.identifier, owner: self, options: nil)?[0] as? ToastView else { fatalError("Can't load view") }
        
        return toastView
    }
    
    private func show(seconds: Int, view: UIView) {
        
        addSubview(view)
        
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(seconds)) {
            
            UIView.animate(withDuration: 0.3, animations: {
                view.alpha = 0
            }, completion: { completed in
                view.removeFromSuperview()
            })
        }
    }
    
}
