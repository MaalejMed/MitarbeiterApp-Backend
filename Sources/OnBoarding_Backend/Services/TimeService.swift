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
        self.connection = connection
        router.all(middleware: BodyParser())
        submitTimesheet()
        lastSubmission()
    }
    
    //MARK:- POST timesheet
    func submitTimesheet() {
        var responseStatus: HTTPStatusCode?
        router.post("/Time") {request, response, next in
            guard let jsonPayload = Formatter.jsonPayload(request: request) else {
                try response.send("\(HTTPStatusCode.badRequest.rawValue)").end()
                next()
                return
            }
            
            let timeManager = TimeManager(router: self.router, connection: self.connection)
            timeManager.insertTimesheet(json: jsonPayload, completion: { response in
                responseStatus = response
            })
            
            try response.send("\(responseStatus!.rawValue)").end()
            next()
        }
        responseStatus = HTTPStatusCode.unknown
    }
    
    func lastSubmission() {
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
