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
    
    //MARK:-
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
                guard queryResult.asError == nil else {
                    completion(HTTPStatusCode.serviceUnavailable)
                    return
                }
                let _ = (queryResult.success) ? completion(HTTPStatusCode.OK) : completion(HTTPStatusCode.badRequest)
            }
        }
    }
    
    //MARK:- Select last submission
    func selectLastSubmittedDay(associateID: String , completion: @escaping ((String?, HTTPStatusCode?)->())) {
        var date: Any?
        self.connection.connect() {[unowned self] error in
            let timeT = TimeT()
            let query = Select(timeT.day, from: timeT).where(timeT.associateID == associateID).order(by: .DESC(timeT.day)).limit(to: 1)
            self.connection.execute(query: query) {queryResult in
                guard let resultSet = queryResult.asResultSet else {
                    completion(nil, HTTPStatusCode.serviceUnavailable)
                    return
                }
                for row in resultSet.rows {
                    date = row[0]

                    
                }
                guard let dateString = date as? String else {
                    completion(nil, HTTPStatusCode.notFound)
                    return
                }
                completion(dateString, nil)
            }
        }
    }
}
