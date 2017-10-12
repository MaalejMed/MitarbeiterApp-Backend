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
        var payload = "[]"
        router.get("/Authentication") { [unowned self] request, response, next in
            let username = request.queryParameters["username"] ?? ""
            let password = request.queryParameters["password"] ?? ""
            self.connection.connect() {[unowned self] error in
                let associate = AssociateT()
                let query = Select(from: associate).where(associate.identifier == username && associate.password == password)
                self.connection.execute(query: query) {queryResult in
                    guard let resultSet = queryResult.asResultSet else {
                        response.send("")
                        return
                    }
                    for row in resultSet.rows {
                        let associate = Associate(row: row)
                        payload = Mapper().toJSONString(associate, prettyPrint: true)!
                    }
                }
            }
            response.send(payload)
            payload = "[]"
            next()
        }
    }
}
