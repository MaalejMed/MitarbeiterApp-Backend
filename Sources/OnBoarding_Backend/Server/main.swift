import Kitura
import SwiftKueryMySQL
import SwiftKuery

// Create a new router
let router = Router()

let connection = MySQLConnection(host: "localhost", user: "root", password: "mysql", database: "cognizant",
                                 port: 3306, characterSet: nil)

//Authentication services
let loginMS = Login(router: router, connection: connection)

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
    
