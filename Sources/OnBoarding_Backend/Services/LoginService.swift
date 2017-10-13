import Kitura
import SwiftKueryMySQL
import SwiftKuery
import ObjectMapper

class LoginService {
    
    //MARK:- Properties
    var router: Router
    var connection: MySQLConnection
    
    //MARK:- Init
    init(router: Router, connection: MySQLConnection) {
        self.router = router
        self.connection = connection
        login()
    }
    
    //MARK:- MS
    func login() {
        var associate: Associate?
        router.get("/Login") { [unowned self] request, response, next in
            let username = request.queryParameters["username"] ?? ""
            let password = request.queryParameters["password"] ?? ""
            self.connection.connect() {[unowned self] error in
                let associateTable = AssociateT()
                let query = Select(from: associateTable).where(associateTable.identifier == username && associateTable.password == password)
                self.connection.execute(query: query) {queryResult in
                    guard let resultSet = queryResult.asResultSet else {
                        response.send("")
                        return
                    }
                    for row in resultSet.rows {
                        associate = Associate(row: row)
                    }
                }
            }
            guard let existingAssociate = associate else {
                response.send("[]")
                return
            }
            
            guard let json = Mapper().toJSONString(existingAssociate, prettyPrint: true) else {
                response.send("")
                return
            }
            response.send(json)
            associate = nil
            next()
        }
    }
}
