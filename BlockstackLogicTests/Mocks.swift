//
//  Mocks.swift
//  BlockstackLogicTests
//
//  Created by Michal Ciurus on 23/04/2018.
//  Copyright © 2018 michalciurus. All rights reserved.
//

@testable import BlockstackInterface

class BlockstackInterfaceMock: BlockstackInterfaceProtocol {
    func getNames(page: Int, completion: @escaping (Result<[String]>) -> Void) {
        
        completion(Result.success(["test"]))
    }
    
    func getExists(name: String, completion: @escaping (Result<Bool>) -> Void) {
        completion(.success(true))
    }
    
    func getProfile(name: String, completion: @escaping (Result<ProfileResponse>) -> Void) {
        let profile = Profile(description: "a", name: "a", image: nil, account: nil)
        let response = ProfileResponse(profile: profile)
        completion(Result.success(response))
    }
    
    func getBitcoinPrice(name: String, completion: @escaping (Result<Double>) -> Void) {
        completion(Result.success(3.2))
    }
    
    func getHistory(name: String, completion: @escaping (Result<NameHistoryResponse>) -> Void) {
    }
    
    
}
