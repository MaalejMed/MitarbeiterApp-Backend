import Foundation
import Kitura
import SwiftKueryMySQL
import SwiftKuery
import KituraNet
import ObjectMapper
import SwiftyJSON

class TimeManager {
    //MARK:- Properties
    var router: Router
    var connection: MySQLConnection
    
    //MARK:- Init
    init(router: Router, connection: MySQLConnection) {
        self.router = router
        self.connection = connection
        router.all(middleware: BodyParser())
    }
    
    //MARK:- Insert time
    func insertTimesheet(json: JSON, completion: @escaping (HTTPStatusCode)->()) {
        guard let timesheet = Timesheet(row: json) else {
            completion(HTTPStatusCode.badRequest)
            return
        }

        self.connection.connect() { [weak self] error in
            let tsTable = TimeT()
            let query = Insert(into: tsTable,
                               columns:[tsTable.associateID, tsTable.day, tsTable.projectID, tsTable.activity, tsTable.billable, tsTable.workFrom, tsTable.workUntil, tsTable.workedHours, tsTable.lunchBreak],
                               values: [timesheet.associateID!, timesheet.day!, timesheet.projectID!, timesheet.activity!, timesheet.billable!, timesheet.workFrom!, timesheet.workUntil!, timesheet.workedHours!, timesheet.lunchBreak!])
            
            self?.connection.execute(query: query) { queryResult in
                let _ = (queryResult.success) ? completion(HTTPStatusCode.OK) : completion(HTTPStatusCode.badRequest)
            }
        }
    }
}
