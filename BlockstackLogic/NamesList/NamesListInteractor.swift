//  Created by Michal Ciurus

import SharedTools
import BlockstackInterface

fileprivate enum NamesListInteractorConstants {
    /// Represents a point when pagination will be triggered
    /// 1.0 means last item, 0.0 means first item
    static let paginationMarginTrigger = 0.7
    static let userNameSuffix = ".id"
}


final public class NamesListInteractor {
    
    fileprivate typealias C = NamesListInteractorConstants
    
    //MARK: Private Properties
    
    private let blockstackInterface: BlockstackInterfaceProtocol!
    private var currentPage = 0
    fileprivate var currentPaginationTrigger: Int? = nil
    private var lastSearch: String?
    
    //MARK: Public Properties
    
    public let presenter = NamesListPresenter()
    
    //MARK: Public Methods
    
    public init(blockstackInterface: BlockstackInterfaceProtocol) {
        self.blockstackInterface = blockstackInterface
    }
    
    public func fetchInitialNames() {
        blockstackInterface.getNames(page: 0) { [weak self] result in
            switch result {
            case .success(let names):
                self?.currentPaginationTrigger = nil
                self?.presenter.cleanNames()
                self?.currentPage = 0
                self?.presenter.set(names: names)
                if names.count > 0 {
                    self?.setCurrentPaginationTrigger(numberOfItems: names.count)
                }
            case .error:
                self?.presenter.errorEvent.fireEvent(with: "Can't fetch names")
            }
        }
    }
    
    public func fetchNextPage() {
        presenter.showLoadMore.value = false
        presenter.isLoadingMore.value = true
        blockstackInterface.getNames(page: currentPage + 1) { [weak self] result in
            self?.presenter.isLoadingMore.value = false
            switch result {
            case .success(let newNames):
                self?.currentPage += 1
                self?.presenter.add(names: newNames)
                if newNames.count > 0 {
                    self?.setCurrentPaginationTrigger(numberOfItems: newNames.count)
                }
            case .error:
                self?.presenter.showLoadMore.value = true
            }
        }
    }
    
    public func search(name: String) {
        presenter.infoLabel.value = nil
        var userName = name
        if !userName.hasSuffix(C.userNameSuffix) {
            userName = "\(userName)\(C.userNameSuffix)"
        }
        presenter.isLoadingMore.value = true
        lastSearch = userName
        blockstackInterface.getExists(name: userName.lowercased()) { [weak self] result in
            guard self?.lastSearch == userName else { return }
            switch result {
            case .success(let exists):
                self?.blockstackInterface.getBitcoinPrice(name: userName.lowercased()) { result in
                    self?.presenter.isLoadingMore.value = false
                    switch result {
                    case .success(let price):
                        self?.presenter.show(name: userName, available: !exists, price: price)
                    case .error:
                        self?.presenter.show(name: userName, available: !exists, price: nil)
                    }
                }
            case .error:
                self?.presenter.errorEvent.fireEvent(with: "Search failed")
                self?.presenter.isLoadingMore.value = false
            }
        }
    }
    
    public func showAllNames() {
        presenter.showAllNames()
    }
    
    public func willDisplay(nameIndex: Int) {
        guard let trigger = currentPaginationTrigger else { return }
        if nameIndex >= trigger {
            fetchNextPage()
            currentPaginationTrigger = nil
        }
    }
    
}

private extension NamesListInteractor {
    
    /// Sets the next pagination trigger after new items have been fetched
    ///
    /// - Parameter numberOfItems: number of items freshly fetched
    func setCurrentPaginationTrigger(numberOfItems: Int) {
        let marginTrigger = floor(Double(numberOfItems) * C.paginationMarginTrigger)
        assert(marginTrigger < Double(numberOfItems))
        currentPaginationTrigger = currentPage * numberOfItems + Int(marginTrigger)
    }
    
}
