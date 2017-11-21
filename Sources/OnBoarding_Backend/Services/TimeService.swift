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
        lastSubmittedDay()
    }
    
    //MARK:-
    func submitTimesheet() {
        var responseStatus: HTTPStatusCode?
        router.post("/SubmitTimesheet") {request, response, next in
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
    
    func lastSubmittedDay() {
        var responseStatus: HTTPStatusCode?
        var lastSubmittedDay: String?
        router.get("/LastSubmittedDay") { [unowned self] request, response, next in
            let associateID = request.queryParameters["associateID"] ?? ""
            let timeManager = TimeManager(router: self.router, connection: self.connection)
            timeManager.selectLastSubmittedDay(associateID: "645438", completion: { day, failure in
                lastSubmittedDay = day
                responseStatus = failure
            })
            
            let _ = (lastSubmittedDay != nil && responseStatus == nil) ? try response.send(lastSubmittedDay!).end() : try response.send("\(responseStatus!.rawValue)").end()
            next()
          
        }
    }
}
