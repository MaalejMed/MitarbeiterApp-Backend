import Foundation
import Kitura
import SwiftKueryMySQL
import SwiftKuery
import KituraNet
import ObjectMapper
import SwiftyJSON

class AuthenticationManager {
    
    //MARK:- Properties
    var router: Router
    var connection: MySQLConnection
    
    //MARK:- Init
    init(router: Router, connection: MySQLConnection) {
        self.router = router
        self.connection = connection
        router.all(middleware: BodyParser())
    }
    
    //MARK:- Login
    func login(associateID: String, password: String, completion: @escaping (HTTPStatusCode)->()) {
        self.connection.connect() { error in
            let associateTable = AssociateT()
            let query = Select(from: associateTable).where(associateTable.identifier == associateID && associateTable.password == password)
            self.connection.execute(query: query) {queryResult in
                guard queryResult.asResultSet != nil else {
                    completion(HTTPStatusCode.serviceUnavailable)
                    return
                }
                
                let _ = queryResult.asRows?.count == 1 ? completion(HTTPStatusCode.OK) : completion(HTTPStatusCode.unauthorized)
            }
        }
    }
}
