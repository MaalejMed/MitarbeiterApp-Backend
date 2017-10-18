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
    
    //MARK: Select user
    func selectAssociate(username: String, password: String, completion: @escaping (String?, HTTPStatusCode?)->()) {
        var associate: Associate?
        self.connection.connect() {[unowned self] error in
            let associateTable = AssociateT()
            let query = Select(from: associateTable).where(associateTable.identifier == username && associateTable.password == password)
            self.connection.execute(query: query) {queryResult in
                guard let resultSet = queryResult.asResultSet else {
                    completion(nil, HTTPStatusCode.serviceUnavailable)
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
            completion(nil, HTTPStatusCode.badRequest)
            return
        }
        
        completion(associateJson, nil)
    }
    
    // MARK:- Update profile image
    func updateAssociatePhoto(json: JSON, completion: @escaping (HTTPStatusCode)->()) {
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
                guard queryResult.success == true else {
                    completion(HTTPStatusCode.badRequest)
                    return
                }
            }
        }
        completion(HTTPStatusCode.OK)
    }
}
