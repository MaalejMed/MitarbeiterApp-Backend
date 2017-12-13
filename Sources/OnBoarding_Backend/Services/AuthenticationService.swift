import Kitura
import SwiftKuery
import KituraNet
import SwiftKueryMySQL

class AuthenticationService {
    
    //MARK:- Properties
    var router: Router
    var connection: MySQLConnection
    
    //MARK:- Init
    init(router: Router, connection: MySQLConnection) {
        self.router = router
        self.connection = connection
        router.all(middleware: BodyParser())
        login()
    }
    
    //MARK:- Login
    func login() {
        router.get("/login") { [unowned self] request, response, next in
            let associateID = request.queryParameters["associateID"] ?? ""
            let password = request.queryParameters["password"] ?? ""
            let authManager = AuthenticationManager(router: self.router, connection: self.connection)
            authManager.login(associateID: associateID, password: password, completion: { httpCodeStatus in
                response.send("\(httpCodeStatus.rawValue)")
                next()
            })
        }
    }
}
