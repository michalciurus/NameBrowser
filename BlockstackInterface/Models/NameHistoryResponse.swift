//  Created by Michal Ciurus

import Foundation

public enum NameOperationType: String, Codable {
    case update = "NAME_UPDATE"
    case renewal = "NAME_RENEWAL"
    case importOp = "NAME_IMPORT"
    case transfer = "NAME_TRANSFER"
    case preorder = "NAME_PREORDER"
    case registration = "NAME_REGISTRATION"
}

public struct NameOperation: Codable {
    public let opcode: NameOperationType
}

public struct NameHistoryResponse: Codable {
    public let operations: [NameOperation]?
}
