import Foundation
import SwiftyJSON


struct Timesheet {
    
    //MARK:- Properties
    var associateID: String?
    var day: Date?
    var workFrom: Date?
    var workUntil: Date?
    var workedHours: String?
    var lunchBreak: String?
    var projectID: String?
    var activity: String?
    var billable: String?
    
    //MARK:- Init
    init(row: JSON) {
        if let assocID = row["associateID"].string {
            associateID = assocID
        }
        
        if let projID = row["projectID"].string {
            projectID = projID
        }

        if let act = row["activity"].string {
            activity = act
        }

        if let bill = row["billable"].string {
            billable = bill
        }

        if  let lunch = row["lunchBreak"].string {
            lunchBreak = lunch
        }

        if let wHours = row["workedHours"].string {
            workedHours = wHours
        }

        if let dayString = row["day"].string {
            day = dayString.simpleDateFormat()
        }

        if let workFromString = row["workFrom"].string {
            workFrom = workFromString.longDateFormat()
        }

        if let workUntilString = row["workUntil"].string {
            workUntil = workUntilString.longDateFormat()
        }
    }
    
}
