import Kitura
import SwiftKueryMySQL
import SwiftKuery
import ObjectMapper
import Foundation

class FeedService {
    
    //MARK:- Properties
    var router: Router
    var connection: MySQLConnection
    
    //MARK:- Init
    init(router: Router, connection: MySQLConnection) {
        self.router = router
        self.connection = connection
        fetch()
    }
    
    //MARK:- Fetch
    func fetch() {
        var feeds : [Feed] = []
        router.get("/Feed") { [unowned self] request, response, next in
            self.connection.connect() {[unowned self] error in
                let feed = FeedT()
                let query = Select(from: feed).order(by: .DESC(feed.date))
                self.connection.execute(query: query) {queryResult in
                    guard let resultSet = queryResult.asResultSet else {
                        response.send("")
                        return
                    }
                    for row in resultSet.rows {
                        feeds.append(Feed(row: row))
                    }
                }
            }
            guard let json = feeds.toJSONString(prettyPrint: true) else {
                response.send("")
                return
            }
            response.send(json)
            feeds.removeAll()
            next()
        }
    }
}
