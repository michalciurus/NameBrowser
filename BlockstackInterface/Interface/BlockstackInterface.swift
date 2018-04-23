//  Created by Michal Ciurus

import Foundation

public protocol BlockstackInterfaceProtocol {
    func getNames(page: Int, completion: @escaping (Result<[String]>) -> Void)
    func getExists(name: String, completion: @escaping (Result<Bool>) -> Void)
    func getProfile(name: String, completion: @escaping (Result<ProfileResponse>) -> Void)
    func getBitcoinPrice(name: String, completion: @escaping (Result<Double>) -> Void)
    func getHistory(name: String, completion: @escaping (Result<NameHistoryResponse>) -> Void)
}

final public class BlockstackInterface: BlockstackInterfaceProtocol {
    
    public init () { }
    
    public func getNames(page: Int, completion: @escaping (Result<[String]>) -> Void) {
        BlockstackCoreRequest<[String]>.getNames(page).execute { result in
            completion(result)
        }
    }
    
    public func getExists(name: String, completion: @escaping (Result<Bool>) -> Void) {
        BlockstackCoreRequest<NameStatusResponse>.getNameExists(name).execute { result in
            switch result {
            case .success(let response): completion(.success(response.status == .registered || response.error == .nameExpired))
            case .error: completion(.error)
            }
        }
    }
    
    public func getProfile(name: String, completion: @escaping(Result<ProfileResponse>) -> Void) {
        BlockstackCoreRequest<ProfileResponse>.getProfile(name).execute { result in
            completion(result)
        }
    }
    
    public func getBitcoinPrice(name: String, completion: @escaping(Result<Double>) -> Void) {
        BlockstackCoreRequest<NamePriceResponse>.getNamePrice(name).execute { result in
            switch result {
            case .success(let response):
                completion(.success(response.estimatedCost.btc))
            case .error: completion(.error)
            }
        }
    }
    
    public func getHistory(name: String, completion: @escaping (Result<NameHistoryResponse>) -> Void) {
        BlockstackCoreRequest<NameHistoryResponse>.getNameHistory(name).execute { result in
            completion(result)
        }
    }

    
}
