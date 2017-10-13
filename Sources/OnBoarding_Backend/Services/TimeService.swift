import Kitura
import SwiftKueryMySQL
import SwiftKuery
import ObjectMapper
import Foundation
import KituraNet

class TimeService {
    //MARK:- Properties
    var router: Router
    var connection: MySQLConnection
    
    //MARK:- Init
    init(router: Router, connection: MySQLConnection) {
        self.router = router
        router.all(middleware: BodyParser())
        self.connection = connection
        submit()
        lastSubmittedDay()
    }
    
    func submit() {
        var responseStatus = 0
        router.post("/Time") {request, response, next in
            guard let body = request.body else {
                responseStatus = HTTPStatusCode.notAcceptable.rawValue
                next()
                return
            }
            switch (body) {
            case .json(let jsonData):
                let timesheet = Timesheet(row: jsonData)
                self.connection.connect() { [weak self] error in
                let timesheetTable = TimeT()

                let query = Insert(into: timesheetTable,
                                   columns:[timesheetTable.associateID, timesheetTable.day, timesheetTable.projectID, timesheetTable.activity, timesheetTable.billable, timesheetTable.workFrom, timesheetTable.workUntil, timesheetTable.workedHours, timesheetTable.lunchBreak],
                                   values: [timesheet.associateID!, timesheet.day!, timesheet.projectID!, timesheet.activity!, timesheet.billable!, timesheet.workFrom!, timesheet.workUntil!, timesheet.workedHours!, timesheet.lunchBreak!])

                    self?.connection.execute(query: query) { queryResult in
                        guard queryResult.success else {
                            responseStatus = HTTPStatusCode.notAcceptable.rawValue
                            next()
                            return
                        }
                        if  queryResult.success {
                            responseStatus = HTTPStatusCode.OK.rawValue
                        } else {
                            responseStatus = HTTPStatusCode.notAcceptable.rawValue
                        }
                    }
                }
                
            default:
                responseStatus = HTTPStatusCode.notAcceptable.rawValue
                next()
                return
            }
           try response.send("\(responseStatus)").end()
            responseStatus = 0
        }
    }
    
    func lastSubmittedDay() {
        var lastSubmittedDay: String?
        router.get("/Time") { [unowned self] request, response, next in
            let associateID = request.queryParameters["associateID"] ?? ""
            self.connection.connect() {[unowned self] error in
                let time = TimeT()
                let query = Select(time.day, from: time).where(time.associateID == associateID).order(by: .DESC(time.day))
                self.connection.execute(query: query) {queryResult in
                    guard let resultSet = queryResult.asResultSet else {
                        response.send("")
                        return
                    }
                    for row in resultSet.rows {
                        lastSubmittedDay =  row[0] as? String ?? ""
                        break
                    }
                }
            }
            
            guard let day = lastSubmittedDay else {
                response.send("[]")
                return
            }
            response.send(day)
            lastSubmittedDay = nil
            next()
        }
    }
}
