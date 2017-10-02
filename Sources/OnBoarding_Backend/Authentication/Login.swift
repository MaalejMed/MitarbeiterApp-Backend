import Kitura
import SwiftKueryMySQL
import SwiftKuery

class Login {
    
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
        router.get("/Authentication") { [unowned self] request, response, next in
            let username = request.queryParameters["username"] ?? ""
            let password = request.queryParameters["password"] ?? ""
            self.connection.connect() {[unowned self] error in
                let associate = Associate()
                let query = Select(from: associate).where(
                    (associate.identifier == username) && (associate.password == password)
                )
                self.connection.execute(query: query) {[unowned self] queryResult in
                    guard let resultSet = queryResult.asResultSet else {
                        response.send("[]")
                        return
                    }
                    let payload = self.jsonString(rows: resultSet.rows)
                    response.send(payload)
                }
            }
            next()
        }
    }
    
    //MARK:- Parser
    func jsonString(rows: RowSequence) -> String {
        var jsonString: String = ""
        for row in rows {
            jsonString += "{"
            let name = row[0] as? String ?? ""
            let email = row[1] as? String ?? ""
            let identifier = row[2] as? String ?? ""
            let password = row[3] as? String ?? ""
            jsonString += "\"name\": \"\(name)\", \"email\": \"\(email)\", \"identifier\": \"\(identifier)\", \"password\": \"\(password)\"}"
        }
       
        return jsonString
    }
}
