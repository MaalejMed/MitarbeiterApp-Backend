import Foundation
import Kitura
import SwiftKueryMySQL
import SwiftKuery
import KituraNet
import ObjectMapper

class AssociateManager {
    
    //MARK:- Properties
    var router: Router
    var connection: MySQLConnection
    
    //MARK:- Init
    init(router: Router, connection: MySQLConnection) {
        self.router = router
        self.connection = connection
        router.all(middleware: BodyParser())
    }
    
    //MARK: Get user
    func fetchAssociate(username: String, password: String, completion: @escaping (String?, HTTPStatusCode?)->()) {
        var associate: Associate?
        self.connection.connect() {[unowned self] error in
            let associateTable = AssociateT()
            let query = Select(from: associateTable).where(associateTable.identifier == username && associateTable.password == password)
            self.connection.execute(query: query) {queryResult in
                guard let resultSet = queryResult.asResultSet else {
                    completion(nil, HTTPStatusCode.notFound)
                    return
                }
                for row in resultSet.rows {
                    associate = Associate(row: row)
                }
            }
        }
        guard let existingAssociate = associate else {
            completion(nil, HTTPStatusCode.unauthorized)
            return
        }
        
        guard let associateJson = Mapper().toJSONString(existingAssociate, prettyPrint: true) else {
            completion(nil, HTTPStatusCode.unknown)
            return
        }
        
        completion(associateJson, nil)
    }
}
