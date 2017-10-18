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
    init?(row: JSON) {
        guard let assocID = row["associateID"].string,
              let projID = row["projectID"].string,
              let act = row["activity"].string,
              let bill = row["billable"].string,
              let lunch = row["lunchBreak"].string,
              let wHours = row["workedHours"].string,
              let dayString = row["day"].string,
              let workFromString = row["workFrom"].string,
              let workUntilString = row["workUntil"].string else {
            return nil
        }

        associateID = assocID
        projectID = projID
        activity = act
        billable = bill
        lunchBreak = lunch
        workedHours = wHours
        day = dayString.simpleDateFormat()
        workFrom = workFromString.longDateFormat()
        workUntil = workUntilString.longDateFormat()
    }
    
}
