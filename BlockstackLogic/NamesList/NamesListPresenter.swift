//  Created by Michal Ciurus

import SharedTools

fileprivate struct NameListPresenterConstants {
    fileprivate static let nameAvailableLabel = "Name available"
}

final public class NamesListPresenter: EmitsError {
    
    fileprivate typealias C = NameListPresenterConstants
    
    //MARK: Private Properties
    
    private var allNames: [String] = []
    private var isShowingOneName = false
    
    //MARK: Public Properties
    
    public var errorEvent =  PresenterEventObservable<String>() 
    public var names = PresenterValueObservable<[String]>(value: [ ])
    public var showLoadMore = PresenterValueObservable<Bool>(value: false)
    public var isLoadingMore = PresenterValueObservable<Bool>(value: false)
    public var infoLabel = PresenterValueObservable<String>(value: nil)
    
    //MARK: Public Methods

    
    func cleanNames() {
        names.value = [ ]
    }
    
    func set(names: [String]) {
        self.names.value = names
    }
    
    func add(names: [String]) {
        var currentValue = self.names.value
        currentValue?.append(contentsOf: names)
        self.names.value = currentValue
    }
    
    func show(name: String, available: Bool, price: Double?) {
        if !isShowingOneName {
            allNames = names.value ?? []
            isShowingOneName = true
        }
        if available {
            names.value = []
            if let price = price {
                infoLabel.value = "\(C.nameAvailableLabel) for \(price) btc"
            } else {
                infoLabel.value = "\(C.nameAvailableLabel)!"
            }
        } else {
            names.value = [name]
            infoLabel.value = nil
        }
    }
    
    func showAllNames() {
        isShowingOneName = false
        names.value = allNames
    }

}
