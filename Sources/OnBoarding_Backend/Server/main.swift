import Kitura
import SwiftKueryMySQL
import SwiftKuery

//MARK:- Create a new router
let router = Router()



//MARK:- Associate services
let asConnection = MySQLConnection(host: "localhost", user: "root", password: "mysql", database: "cognizant",
                                 port: 3306, characterSet: nil)
let associateService = AssociateService(router: router, connection: asConnection)

//MARK:- Feed services
let fsConnection = MySQLConnection(host: "localhost", user: "root", password: "mysql", database: "cognizant",
                                 port: 3306, characterSet: nil)
let feedService = FeedService(router: router, connection: fsConnection)

//MARK:- Time services
let tsConnection = MySQLConnection(host: "localhost", user: "root", password: "mysql", database: "cognizant",
                                 port: 3306, characterSet: nil)
let timeService = TimeService(router: router, connection: tsConnection)

//MARK: - Message services
let msConnection = MySQLConnection(host: "localhost", user: "root", password: "mysql", database: "cognizant",
                                   port: 3306, characterSet: nil)
let messageService = MessageService(router: router, connection: msConnection)

//MARK:-Start Service
Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
    
