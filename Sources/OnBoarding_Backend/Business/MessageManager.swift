
import Foundation
import Kitura
import SwiftKueryMySQL
import SwiftKuery
import KituraNet
import ObjectMapper
import SwiftyJSON

class MessageManager {
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
    func insertMessage(json: JSON, completion: @escaping (HTTPStatusCode)->()) {
        guard let message = Message(row: json) else {
            completion(HTTPStatusCode.badRequest)
            return
        }
        self.connection.connect() { [weak self] error in
            let msgTable = MessageT()
            let query = Insert(into: msgTable,
                               columns:[msgTable.associateID, msgTable.identifier, msgTable.title, msgTable.body, msgTable.date],
                               values: [message.associateID!, message.identifier!, message.title!, message.body!, message.date!])
            self?.connection.execute(query: query) { queryResult in
                guard queryResult.asError == nil else {
                    completion(HTTPStatusCode.serviceUnavailable)
                    return
                }
                let _ = (queryResult.success) ? completion(HTTPStatusCode.OK) : completion(HTTPStatusCode.badRequest)
            }
        }
    }
    
    //MARK:-
    func selectMessages(associateID: String , completion: @escaping ((String?, HTTPStatusCode?)->())) {
        self.connection.connect() {[unowned self] error in
            var messages : [Message] = []
            let messagesT = MessageT()
            let query = Select(from: messagesT).where(messagesT.associateID == associateID).order(by: .DESC(messagesT.date))
            self.connection.execute(query: query) {queryResult in
                guard let resultSet = queryResult.asResultSet else {
                    completion(nil, HTTPStatusCode.serviceUnavailable)
                    return
                }
                for row in resultSet.rows {
                    messages.append(Message(row: row))
                }
            }
            guard let json = messages.toJSONString(prettyPrint: true) else {
                completion(nil, HTTPStatusCode.badRequest)
                return
            }
            completion(json, nil)
        }
    }
}
