import Foundation
import Kitura
import SwiftKuery
import KituraNet
import SwiftKueryMySQL

class AssociateService {
    
    //MARK:- Properties
    var router: Router
    var connection: MySQLConnection
    
    //MARK:- Init
    init(router: Router, connection: MySQLConnection) {
        self.router = router
        self.connection = connection
        router.all(middleware: BodyParser())
        fetchData()
        updatePhoto()
    }
    
    //MARK:- GET: Login
    func fetchData() {
        router.get("/data") { request, response, next in
            let associateID = request.queryParameters["associateID"] ?? ""
            let associateManager = AssociateManager(router: self.router, connection: self.connection)
            associateManager.fetchData(associateID: associateID, completion: { associate, failure in
                guard associate != nil,  failure == nil else {
                    response.send("\(failure!.rawValue)")
                    return
                }
                response.send(associate!)
                next()
            })
        }
    }
    
    //MARK:- POST: Profile photo
    func updatePhoto() {
        var responseStatus: HTTPStatusCode = HTTPStatusCode.unknown
        router.post("/photo") {request, response, next in
            guard let jsonPayload = Formatter.jsonPayload(request: request) else {
                try response.send("\(HTTPStatusCode.badRequest.rawValue)").end()
                return next()
            }
            
            let associateManager = AssociateManager(router: self.router, connection: self.connection)
            associateManager.updatePhoto(json: jsonPayload, completion: { response in
                responseStatus = response
            })
            
            try response.send("\(responseStatus.rawValue)").end()
            next()
        }
    }
}
