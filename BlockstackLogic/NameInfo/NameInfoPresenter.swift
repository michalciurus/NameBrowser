//  Created by Michal Ciurus

import SharedTools
import BlockstackInterface

public struct NameHistoryPresenter {
    public let operationLabel: String
}

public struct ProfilePresenter {
    public let nameLabel: String
    public let descriptionLabel: String
    public let imageUrl: String?
    public let blockstackNameLabel: String
    public let twitterUrl: String?
}

public class NameInfoPresenter: EmitsError {
    
    //MARK: Private Properties
    
    private let blockstackName: String
    
    //MARK: Public Properties
    
    public var errorEvent =  PresenterEventObservable<String>()
    public let profile = PresenterValueObservable<ProfilePresenter>(value: nil)
    public let nameHistory = PresenterValueObservable<[NameHistoryPresenter]>(value: [ ])
    
    //MARK: Public Methods
    
    public init(name: String) {
        self.blockstackName = name
    }
    
    func set(profile: Profile?) {
        let name = profile?.name ?? "Unknown"
        let description = profile?.description ?? "Description missing"
        let imageUrl = profile?.image?[0].contentUrl
        self.profile.value = ProfilePresenter(nameLabel: name, descriptionLabel: description, imageUrl: imageUrl, blockstackNameLabel: blockstackName, twitterUrl: profile?.getTwitterUrl())
    }
    
    func set(history: NameHistoryResponse) {
        guard let operations = history.operations else { return }
        nameHistory.value = operations.map { operation -> NameHistoryPresenter in
            return NameHistoryPresenter(operationLabel: operation.opcode.rawValue)
        }
    }
    
}
