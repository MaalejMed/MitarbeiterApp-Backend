import Foundation
import ObjectMapper
struct Associate: Mappable {
    
    //MARK: Properties
    var identifier: String?
    var email: String?
    var name: String?
    var password: String?
    var image: String?
    
    init(row: [Any?]) {
        name = row[0] as? String ?? ""
        email = row[1] as? String ?? ""
        identifier = row[2] as? String ?? ""
        password = row[3] as? String ?? ""
        image = row[4] as? String ?? ""
    }
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        identifier <- map["identifier"]
        email <- map["email"]
        name <- map["name"]
        password <- map["password"]
        image <- map["photo"]
    }
}
