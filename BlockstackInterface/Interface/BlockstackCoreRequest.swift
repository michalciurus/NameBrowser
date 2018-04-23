//  Created by Michal Ciurus

import Foundation

public enum Result<T> {
    case success(T)
    case error
}

enum Parameters: String {
    case page
}

enum BlockstackCoreRequest<ResponseType> where ResponseType: Codable {
    
    case getNames(Int)
    case getProfile(String)
    case getNameExists(String)
    case getNamePrice(String)
    case getNameHistory(String)
    
    var path: String {
        switch self {
        case .getNames: return "/v1/names"
        case .getProfile(let name): return "/v1/users/\(name)"
        case .getNameExists(let name): return "/v1/names/\(name)"
        case .getNamePrice(let name): return "/v1/prices/names/\(name)"
        case .getNameHistory(let name): return "/v1/names/\(name)/history"
        }
    }
    
    func execute(completion: @escaping (Result<ResponseType>) -> Void) {
        let requestUrlString = "\(InterfaceConstants.baseUrl)\(path)"
        guard var urlComponents = URLComponents(string: requestUrlString) else { fatalError("Wrong URL") }
        
        switch self {
        case .getNames(let page):
            urlComponents.queryItems = [ URLQueryItem(name: Parameters.page.rawValue, value: "\(page)")]
        default: break
        }
        
        guard let url = urlComponents.url else { fatalError("Wrong URL") }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.error)
                return
            }
            
            guard let responseObject = self.getResponseObject(data: data) else {
                completion(.error)
                return
            }
            
            completion(.success(responseObject))
            }.resume()
    }
    
    private func getResponseObject(data: Data) -> ResponseType? {
        
        switch self {
        case .getProfile(let name):
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            let nestedJson = json??[name]
            guard let profileJson = nestedJson else { fatalError("Can't find nested JSON") }
            let nestedData = try? JSONSerialization.data(withJSONObject: profileJson, options: [])
            return try? JSONDecoder().decode(ResponseType.self, from: nestedData!)
        case .getNameHistory:
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            guard let values = json??.values else { fatalError("Can't find nested JSON") }
            var nestedObjects: [[String : Any]] = [ ]
            for value in values {
                guard let object = (value as? [[String:Any]]) else { continue }
                nestedObjects.append(object[0])
            }
            let historyDictionary = ["operations" : nestedObjects]
            let nestedData = try? JSONSerialization.data(withJSONObject: historyDictionary, options: [])
            return try? JSONDecoder().decode(ResponseType.self, from: nestedData!)
        default:
            return try? JSONDecoder().decode(ResponseType.self, from: data)
        }
        
    }
    
}
