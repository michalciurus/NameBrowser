//  Created by Michal Ciurus

import Foundation

public struct Cost: Codable {
    public let btc: Double
}

public struct NamePriceResponse: Codable {
    public let estimatedCost: Cost
    
    private enum CodingKeys: String, CodingKey {
        case estimatedCost = "total_estimated_cost"
    }
}
