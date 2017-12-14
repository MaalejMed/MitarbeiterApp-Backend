import Foundation
import Kitura
import SwiftKueryMySQL
import SwiftKuery
import KituraNet
import ObjectMapper
import SwiftyJSON

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
    
    //MARK:-
    func fetchData(associateID: String, completion: @escaping (String?, HTTPStatusCode?)->()) {
        self.connection.connect() {[unowned self] error in
            let associateTable = AssociateT()
            let query = Select(from: associateTable).where(associateTable.identifier == associateID)
            self.connection.execute(query: query) {queryResult in
                guard let resultSet = queryResult.asResultSet else {
                    completion(nil, HTTPStatusCode.serviceUnavailable)
                    return
                }
                
                var assRow: [Any?] = []
                
                for row in resultSet.rows {
                    assRow = row
                }
                
                guard let associate = Associate(row: assRow) else {
                    completion(nil, HTTPStatusCode.unauthorized)
                    return
                }
                
                guard let jsonPayload = Mapper().toJSONString(associate, prettyPrint: true) else {
                    completion(nil, HTTPStatusCode.badRequest)
                    return
                }
                completion(jsonPayload, nil)
            }
        }

    }
    
    // MARK:-
    func updatePhoto(json: JSON, completion: @escaping (HTTPStatusCode)->()) {
        guard let imageString = json["photo"].string, let associateID = json["associateID"].string else {
            completion(HTTPStatusCode.badRequest)
            return
        }
        
        guard let imagePath = PhotoManager.save(image: imageString, associateID: associateID) else {
            completion(HTTPStatusCode.badRequest)
            return
        }
        
        self.connection.connect() { [weak self] error in
            let associateTable = AssociateT()
            let query = Update(associateTable, set:[(associateTable.photo, imagePath)]).where(associateTable.identifier == associateID)
            self?.connection.execute(query: query) { queryResult in
                guard queryResult.asError == nil else {
                    completion(HTTPStatusCode.serviceUnavailable)
                    return
                }
                let _ =  queryResult.success == true ?  completion(HTTPStatusCode.OK): completion(HTTPStatusCode.badRequest)
            }
        }
    }
}
