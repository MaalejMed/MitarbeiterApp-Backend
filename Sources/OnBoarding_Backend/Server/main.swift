import Kitura
import SwiftKueryMySQL
import SwiftKuery

// Create a new router
let router = Router()

let connection = MySQLConnection(host: "localhost", user: "root", password: "mysql", database: "cognizant",
                                 port: 3306, characterSet: nil)

let loginMS = Login(router: router, connection: connection)

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8080, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
    
