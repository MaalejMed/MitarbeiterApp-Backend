import Foundation
import SwiftyJSON
import ObjectMapper

struct Message: Mappable {
    
    //MARK:- Properties
    var identifier: String?
    var title: String?
    var body: String?
    var associateID: String?
    var date: Date?
    
    //MARK:- Init
    init?(row: JSON) {
        guard let assocID = row["associateID"].string,
            let ident = row["identifier"].string,
            let titl = row["title"].string,
            let bod = row["body"].string,
            let dat = row["date"].string else {
                return nil
        }
        
        associateID = assocID
        identifier = ident
        body = bod
        date = dat.simpleDateFormat()
        title = titl
    }
    
    init(row: [Any?]) {
        associateID = row[0] as? String ?? ""
        title = row[1] as? String ?? ""
        body = row[2] as? String ?? ""
        let dateString = row[3] as? String ?? nil
        date = dateString?.simpleDateFormat()
        identifier = row[4] as? String ?? ""
    }
    
    //MARK:- mappable
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        identifier <- map["identifier"]
        associateID <- map["associateID"]
        title <- map["title"]
        body <- map["body"]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date <- (map["date"], DateFormatterTransform(dateFormatter: dateFormatter))
    }
    
}
