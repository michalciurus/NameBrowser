//  Created by Michal Ciurus

import Foundation

enum NameStatus: String, Codable {
    case registered
    case available
}

enum NameStatusErrorType: String, Codable {
    case nameExpired = "Name expired"
}

struct NameStatusResponse: Codable {
    var status: NameStatus?
    var error: NameStatusErrorType?
}
