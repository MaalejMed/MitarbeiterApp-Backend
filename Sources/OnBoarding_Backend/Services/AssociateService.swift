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
        fetchProfileData()
        changeProfilePhoto()
    }
    
    //MARK:- GET: Login
    func fetchProfileData() {
        router.get("/profile") { [unowned self] request, response, next in
            let associateID = request.queryParameters["associateID"] ?? ""
            let associateManager = AssociateManager(router: self.router, connection: self.connection)
            associateManager.fetchProfileData(associateID: associateID, completion: { associate, failure in
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
    func changeProfilePhoto() {
        var responseStatus: HTTPStatusCode?
        router.post("/ChangeProfilePhoto") {request, response, next in
            guard let jsonPayload = Formatter.jsonPayload(request: request) else {
                try response.send("\(HTTPStatusCode.badRequest.rawValue)").end()
                next()
                return
            }
            
            let associateManager = AssociateManager(router: self.router, connection: self.connection)
            associateManager.updateAssociatePhoto(json: jsonPayload, completion: { response in
                responseStatus = response
            })
            
            try response.send("\(responseStatus!.rawValue)").end()
            next()
        }
        responseStatus = HTTPStatusCode.unknown
    }
}
