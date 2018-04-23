//  Created by Michal Ciurus

import SharedTools
import BlockstackLogic
import BlockstackInterface

final class NameInfoRouter: Routable {
    
    //MARK: Private Properties
    
    private let navigationController: UINavigationController
    private let blockstackInterface: BlockstackInterfaceProtocol
    private let name: String
    
    //MARK: Public Properties
    
    var didFinishRouting = EventObservable<Void>()
    
    //MARK: Public Methods
    
    init(navigationController: UINavigationController, blockstackInterface: BlockstackInterface, name: String) {
        self.navigationController = navigationController
        self.blockstackInterface = blockstackInterface
        self.name = name
    }
    
    func start() {
        let interactor = NameInfoInteractor(blockstackInterface: blockstackInterface, name: name)
        let nameInfoViewController = NameInfoViewController()
        nameInfoViewController.inject(interactor)
        
        nameInfoViewController.willPop.observe { [weak self] _ in
            self?.didFinishRouting.fireEvent()
        }
        
        navigationController.pushViewController(nameInfoViewController, animated: true)
    }
    
}
