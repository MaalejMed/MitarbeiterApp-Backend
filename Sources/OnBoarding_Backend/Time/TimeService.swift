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
                let assoID = jsonData["associateID"].string ?? ""
                let day = jsonData["day"].string ?? ""
                let projectID = jsonData["projectID"].string ?? ""
                let activity = jsonData["activity"].string ?? ""
                let billable = jsonData["billable"].string ?? ""
                let startWork = jsonData["from"].string ?? ""
                let endWork = jsonData["until"].string ?? ""
                let workedHours = jsonData["workedHours"].string ?? ""
                let lunchBreak = jsonData["lunchBreak"].string ?? ""
                self.connection.connect() { [weak self] error in
                    let timesheet = TimeT()
                    let query = Insert(into: timesheet,
                                       columns:[timesheet.associateID, timesheet.day, timesheet.projectID, timesheet.activity, timesheet.billable, timesheet.startWork, timesheet.endWork, timesheet.workedHours, timesheet.lunchBreak],
                                       values: [assoID, day, projectID, activity, billable, startWork, endWork, workedHours, lunchBreak])
                    
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
                next()
                return
            }
           try response.send("\(responseStatus)").end()
            responseStatus = 0
        }
    }
    
    func lastSubmittedDay() {
        var payload = "[]"
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
                        payload = String(describing: row)
                        break
                    }
                }
            }
            response.send(payload)
            payload = "[]"
            next()
        }
    }
}
