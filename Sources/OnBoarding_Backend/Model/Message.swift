import Foundation
import SwiftyJSON

struct Message {
    
    //MARK:- Properties
    let identifier: String?
    let title: String?
    let body: String?
    let associateID: String?
    let date: Date?
    
    //MARK:- Init
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
}
