import Foundation
import Kitura
import SwiftKueryMySQL
import SwiftKuery
import KituraNet
import ObjectMapper

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
        router.get("/AssociateLogin") { [unowned self] request, response, next in
            let username = request.queryParameters["username"] ?? ""
            let password = request.queryParameters["password"] ?? ""
            
            let associateManager = AssociateManager(router: self.router, connection: self.connection)
            associateManager.fetchAssociate(username: username, password: password, completion: { associate, failure in
                guard let exsitingAssociate = associate else {
                    response.send("\(failure!.rawValue)")
                    return
                }
                response.send(exsitingAssociate)
                next()
            })
        }
    }
    
    //MARK:- Update profile photo
    func changeProfilePhoto() {
        var responseStatus = HTTPStatusCode.OK.rawValue
        router.post("/AssociatePhoto") {request, response, next in
            guard let body = request.body else {
                try response.send("\(HTTPStatusCode.badRequest)").end()
                next()
                return
            }
            switch (body) {
            case .json(let jsonData):
                let associateManager = AssociateManager(router: self.router, connection: self.connection)
                associateManager.updateProfileImage(json: jsonData, completion: { failure in
                    responseStatus = (failure != nil) ? failure!.rawValue : HTTPStatusCode.OK.rawValue
                })
                
            default:
                responseStatus = HTTPStatusCode.badRequest.rawValue
                next()
            }
            try response.send("\(responseStatus)").end()
            next()
        }
        responseStatus = HTTPStatusCode.OK.rawValue
    }
}
