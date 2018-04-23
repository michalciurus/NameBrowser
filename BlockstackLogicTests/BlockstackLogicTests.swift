//  Created by Michal Ciurus

import XCTest
@testable import BlockstackLogic
import BlockstackInterface


/// A small sample of how to test Interactor/Presenter logic
class BlockstackLogicTests: XCTestCase {
    
    var interactor: NamesListInteractor!
    var mockInterface: BlockstackInterfaceProtocol!
    
    override func setUp() {
        super.setUp()
        mockInterface = BlockstackInterfaceMock()
        interactor = NamesListInteractor(blockstackInterface: mockInterface)
    }
    
    func testFetching() {
        interactor.fetchInitialNames()
        XCTAssert(interactor.presenter.names.value?[0] == "test")
    }
    
    func testPagination() {
        interactor.fetchInitialNames()
        XCTAssert(interactor.presenter.names.value?.count == 1)
        interactor.fetchNextPage()
        XCTAssert(interactor.presenter.names.value?.count == 2)
        interactor.fetchNextPage()
        XCTAssert(interactor.presenter.names.value?.count == 3)
        interactor.willDisplay(nameIndex: 2)
        XCTAssert(interactor.presenter.names.value?.count == 4)
        interactor.fetchInitialNames()
        XCTAssert(interactor.presenter.names.value?.count == 1)
    }
    
    func testSearch() {
        interactor.search(name: "aa")
        XCTAssert(interactor.presenter.names.value?.count == 1)
        interactor.showAllNames()
        XCTAssert(interactor.presenter.names.value?.count == 0)
    }
    
}
