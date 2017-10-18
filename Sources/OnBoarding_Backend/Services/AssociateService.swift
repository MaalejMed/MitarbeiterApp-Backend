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
        login()
        changeProfilePhoto()
    }
    
    //MARK:- Login
    func login() {
        router.get("/Login") { [unowned self] request, response, next in
            let username = request.queryParameters["username"] ?? ""
            let password = request.queryParameters["password"] ?? ""
            
            let associateManager = AssociateManager(router: self.router, connection: self.connection)
            associateManager.selectAssociate(username: username, password: password, completion: { associate, failure in
                guard let exsitingAssociate = associate else {
                    response.send("\(failure!.rawValue)")
                    return
                }
                response.send(exsitingAssociate)
                next()
            })
        }
    }
    
    //MARK:- Profile photo
    func changeProfilePhoto() {
        var responseStatus = HTTPStatusCode.OK.rawValue
        router.post("/ProfilePhoto") {request, response, next in
            guard let jsonPayload = Formatter.jsonPayload(request: request) else {
                try response.send("\(HTTPStatusCode.badRequest)").end()
                next()
                return
            }
            
            let associateManager = AssociateManager(router: self.router, connection: self.connection)
            associateManager.updateProfileImage(json: jsonPayload, completion: { response in
                responseStatus = response.rawValue
            })
            
            try response.send("\(responseStatus)").end()
            next()
        }
        responseStatus = HTTPStatusCode.OK.rawValue
    }
}
