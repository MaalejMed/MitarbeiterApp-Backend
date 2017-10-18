
import Foundation
import SwiftyJSON
import Kitura

class Formatter {
    
    static func jsonPayload(request: RouterRequest)-> JSON? {
        guard let body = request.body else {
            return nil
        }
        switch (body) {
        case .json(let jsonData):
            return jsonData
        default:
            return nil
        }
    }
}
