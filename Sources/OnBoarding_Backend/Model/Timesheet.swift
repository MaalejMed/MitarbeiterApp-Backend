import Foundation
import ObjectMapper

struct Timesheet: Mappable {
    var associateID: String?
    var day: Date?
    var startWork: Date?
    var endWork: Date?
    var workedHours: String?
    var lunchBreak: String?
    var projectID: String?
    var activity: String?
    var billable: String?
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "HH:mm"
        
        associateID <- map["associateID"]
        day <- (map["day"],DateFormatterTransform(dateFormatter: dateFormatter1))
//        startWork <- (map["startWork"],DateFormatterTransform(dateFormatter: dateFormatter2))
//        startBreak <- (map["startBreak"],DateFormatterTransform(dateFormatter: dateFormatter2))
//        endBreak <- (map["endBreak"], DateFormatterTransform(dateFormatter: dateFormatter2))
//        lunchBreak <- (map["lunchBreak"], DateFormatterTransform(dateFormatter: dateFormatter2))
    }
}
