import Kitura
import SwiftKueryMySQL
import SwiftKuery
import ObjectMapper
import KituraNet

class AssociateService {
    
    //MARK:- Properties
    var router: Router
    var connection: MySQLConnection
    
    //MARK:- Init
    init(router: Router, connection: MySQLConnection) {
        self.router = router
        self.connection = connection
        router.all(middleware: BodyParser())
        login()
        upadateProfilePhoto()
    }
    
    //MARK:- Login
    func login() {
        var associate: Associate?
        router.get("/AssociateLogin") { [unowned self] request, response, next in
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
    
    //MARK:- Update profile photo
    func upadateProfilePhoto() {
        var responseStatus = HTTPStatusCode.OK.rawValue
        router.post("/AssociatePhoto") {request, response, next in
            guard let body = request.body else {
                try response.send("\(HTTPStatusCode.notAcceptable.rawValue)").end()
                next()
                return
            }
            switch (body) {
            case .json(let jsonData):
                guard let imageString = jsonData["photo"].string, let associateID = jsonData["associateID"].string else {
                    try response.send("\(HTTPStatusCode.notAcceptable.rawValue)").end()
                    next()
                    return
                }
                
                guard let imagePath = PhotoManager.save(image: imageString, associateID: associateID) else {
                    try response.send("\(HTTPStatusCode.notAcceptable.rawValue)").end()
                    next()
                    return
                }
                
                self.connection.connect() { [weak self] error in
                    let associateTable = AssociateT()
                    
                    let query = Update(associateTable, set:[(associateTable.photo, imagePath)]).where(associateTable.identifier == associateID)
                    
                    self?.connection.execute(query: query) { queryResult in
                        if queryResult.success == false {
                            responseStatus = HTTPStatusCode.notAcceptable.rawValue
                        }
                    }
                }
            default:
                try response.send("\(HTTPStatusCode.notAcceptable.rawValue)").end()
                next()
                return
            }
            try response.send("\(responseStatus)").end()
            responseStatus = HTTPStatusCode.OK.rawValue
        }
    }
}
