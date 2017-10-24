import Kitura
import SwiftKueryMySQL
import SwiftKuery

//MARK:- Create a new router
let router = Router()

let connection = MySQLConnection(host: "localhost", user: "root", password: "mysql", database: "cognizant",
                                 port: 3306, characterSet: nil)

//MARK:- Associate services
let associateService = AssociateService(router: router, connection: connection)

//MARK:- Feed services
let feedService = FeedService(router: router, connection: connection)

//MARK:- Time services
let timeService = TimeService(router: router, connection: connection)

//MARK: - Message services
let messageService = MessageService(router: router, connection: connection)

//MARK:-Start Service
Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
    
