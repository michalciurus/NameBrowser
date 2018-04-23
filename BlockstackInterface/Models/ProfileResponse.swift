//  Created by Michal Ciurus

import Foundation

public struct Image: Codable {
    public let contentUrl: String
}

public struct Account: Codable {
    let url: String
    let service: String
    
    private enum CodingKeys: String, CodingKey {
        case url = "proofUrl"
        case service
    }
}

public struct Profile: Codable {
    public let description: String?
    public let name: String?
    public let image: [Image]?
    public let account: [Account]?
    
    public func getTwitterUrl() -> String? {
        guard let accounts = self.account else { return nil }
        for account in accounts {
            if account.service == "twitter" {
                return account.url
            }
        }
        return nil
    }
}

public struct ProfileResponse: Codable {
    public let profile: Profile
}
