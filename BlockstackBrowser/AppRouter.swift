//  Created by Michal Ciurus

import SharedTools
import UIKit
import BlockstackInterface
import BlockstackLogic

class AppRouter: Routable {
    
    //MARK: Private Properties
    
    private var window: UIWindow
    private let navigationController: UINavigationController
    private let routerCollection = RouterCollection()
    private let blockstackInterface = BlockstackInterface()
    
    //MARK: Public Properties

    var didFinishRouting = EventObservable<Void>()
    
    //MARK: Public Methohds
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        navigationController.navigationBar.barTintColor = UIColor.blockstackVolet()
        navigationController.navigationBar.tintColor = UIColor.white
        navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
    }

    func start() {
        let storyboard = UIStoryboard(.namesList)
        let interactor = NamesListInteractor(blockstackInterface: blockstackInterface)
        let namesListViewController = NamesListViewController.instantiate(from: storyboard)
        namesListViewController.inject(interactor)
        
        namesListViewController.routeToNameEvent.observe { [weak self] name in
            guard let name = name else { return }
            self?.routeTo(name: name)
        }
        
        navigationController.pushViewController(namesListViewController, animated: true)
        
        window.rootViewController = navigationController
    }

}

private extension AppRouter {
    
    private func routeTo(name: String) {
        let router = NameInfoRouter(navigationController: navigationController, blockstackInterface: blockstackInterface, name: name)
        routerCollection.add(router: router)
        
        router.start()
    }
}
