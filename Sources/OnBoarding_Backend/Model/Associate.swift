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
    
    init(row: [Any?]) {
        name = row[0] as? String ?? ""
        email = row[1] as? String ?? ""
        identifier = row[2] as? String ?? ""
        password = row[3] as? String ?? ""
        imageURL = row[4] as? String ?? ""
        imageString = PhotoManager.readImage(associateID: identifier!)
    }
    
    // Mappable
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        identifier <- map["identifier"]
        email <- map["email"]
        name <- map["name"]
        password <- map["password"]
        imageString <- map["photo"]
    }
}
