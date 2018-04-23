//  Created by Michal Ciurus

import BlockstackInterface

public class NameInfoInteractor {
    
    //MARK: Private Properties
    
    private let blockstackInterface: BlockstackInterfaceProtocol
    
    //MARK: Public Properties
    
    public let presenter: NameInfoPresenter
    public let name: String
    
    //MARK: Public Methods
    
    public init(blockstackInterface: BlockstackInterfaceProtocol, name: String) {
        self.blockstackInterface = blockstackInterface
        self.name = name
        self.presenter = NameInfoPresenter(name: name)
    }
    
    public func fetchInfo() {
        blockstackInterface.getProfile(name: name) { [weak self] result in
            switch result {
            case .success(let profileResponse):
                self?.presenter.set(profile: profileResponse.profile)
            case .error:
                self?.presenter.errorEvent.fireEvent(with: "Can't fetch profile data (endpoint has problems)")
                self?.presenter.set(profile: nil)
            }
        }
        
        blockstackInterface.getHistory(name: name) { [weak self] result in
            switch result {
            case .success(let history):
                self?.presenter.set(history: history)
            case .error:
                self?.presenter.errorEvent.fireEvent(with: "Can't fetch history")
            }
        }
    }
    
}
