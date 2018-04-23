//  Created by Michal Ciurus

import Foundation

final public class RouterCollection {
    
    var routers: [Routable] = []
    
    public init() { }
    
    public func add(router: Routable) {
        routers.append(router)
        
        router.didFinishRouting.observe { [weak self, weak router] in
            guard let strongSelf = self, let router = router else { return }
            strongSelf.routers.remove(at: strongSelf.routers.index { $0 === router }!)
        }
    }
    
}
