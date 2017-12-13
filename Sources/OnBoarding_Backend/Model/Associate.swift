import Foundation
import ObjectMapper
struct Associate: Mappable {
    
    //MARK: Properties
    var identifier: String?
    var email: String?
    var name: String?
    var password: String?
    var imageURL: String?
    var imageString: String?
    
    init?(row: [Any?]) {
        guard let name = row[0] as? String, let email = row[1] as? String, let identifier = row[2] as? String, let password = row[3] as? String else {
            return
        }
        self.name = name
        self.email = email
        self.identifier = identifier
        self.password = password
        imageString = PhotoManager.readImage(associateID: identifier)
    }
    
    // Mappable
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        identifier <- map["identifier"]
        password <- map["password"]
        email <- map["email"]
        name <- map["name"]
        imageString <- map["photo"]
    }
}
