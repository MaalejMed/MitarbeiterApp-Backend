import Kitura
import SwiftKueryMySQL
import SwiftKuery
import ObjectMapper
import Foundation
import KituraNet

class MessageService {
    //MARK:- Properties
    var router: Router
    var connection: MySQLConnection
    
    //MARK:- Init
    init(router: Router, connection: MySQLConnection) {
        self.router = router
        self.connection = connection
        router.all(middleware: BodyParser())
        submitMessage()
        submitSubMessage()
        fetch()
        fetchSubMessages()
    }
    
    func submitMessage() {
        var responseStatus: HTTPStatusCode?
        router.post("/SubmitMessage") {request, response, next in
            guard let jsonPayload = Formatter.jsonPayload(request: request) else {
                try response.send("\(HTTPStatusCode.badRequest.rawValue)").end()
                next()
                return
            }
            let messageManager = MessageManager(router: self.router, connection:self.connection)
            messageManager.insertMessage(json: jsonPayload, completion: { response in
                responseStatus = response
            })
            try response.send("\(responseStatus!.rawValue)").end()
            next()
        }
    }
    
    func submitSubMessage() {
        var responseStatus: HTTPStatusCode?
        router.post("/SubmitSubMessage") {request, response, next in
            guard let jsonPayload = Formatter.jsonPayload(request: request) else {
                try response.send("\(HTTPStatusCode.badRequest.rawValue)").end()
                next()
                return
            }
            let messageManager = MessageManager(router: self.router, connection:self.connection)
            messageManager.insertSubMessage(json: jsonPayload, completion: { response in
                responseStatus = response
            })
            try response.send("\(responseStatus!.rawValue)").end()
            next()
        }
    }
    
    func fetch() {
        router.get("/Message") { [unowned self] request, response, next in
            let associateID = request.queryParameters["associateID"] ?? ""
            let messageManager = MessageManager(router: self.router, connection: self.connection)
            messageManager.selectMessages(associateID: associateID , completion: { messageJson, failure in
                guard let messages = messageJson else {
                    response.send("\(failure!.rawValue)")
                    return
                }
                response.send(messages)
                next()
            })
        }
    }
    
    func fetchSubMessages() {
        router.get("/SubMessage") { [unowned self] request, response, next in
            let messageID = request.queryParameters["messageID"] ?? ""
            let messageManager = MessageManager(router: self.router, connection: self.connection)
            messageManager.selectSubMessages(messageID: messageID , completion: { messageJson, failure in
                guard let messages = messageJson else {
                    response.send("\(failure!.rawValue)")
                    return
                }
                response.send(messages)
                next()
            })
        }
    }
    
}
