import Foundation
import SwiftyJSON
import ObjectMapper

struct SubMessage: Mappable {
    
    //MARK:- Properties
    var identifier: String?
    var body: String?
    var date: Date?
    var messageID: String?
    var owner: Bool?
    
    //MARK:- Init
    init(row: [Any?]) {
        identifier = row[0] as? String ?? ""
        body = row[1] as? String ?? ""
        
        let dateString = row[2] as? String ?? nil
        date = dateString?.simpleDateFormat()
        
        messageID = row[3] as? String ?? ""
        
        
        let  ownerAttribute = row[4] as! NSNumber
        owner = Bool(truncating: ownerAttribute)
    }
    
    //MARK:- mappable
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        identifier <- map["identifier"]
        body <- map["body"]
        messageID <- map["messageID"]
        owner <- map["owner"]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date <- (map["date"], DateFormatterTransform(dateFormatter: dateFormatter))
    }
}
