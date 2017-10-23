import Foundation
import Kitura
import SwiftKueryMySQL
import SwiftKuery
import KituraNet
import ObjectMapper
import SwiftyJSON

class FeedManager {
    //MARK:- Properties
    var router: Router
    var connection: MySQLConnection
    
    //MARK:- Init
    init(router: Router, connection: MySQLConnection) {
        self.router = router
        self.connection = connection
    }
    
    func selectFeeds(completion: @escaping (String?, HTTPStatusCode?)->()) {
        self.connection.connect() {[unowned self] error in
            var feeds : [Feed] = []
            let feed = FeedT()
            let query = Select(from: feed).order(by: .DESC(feed.date))
            self.connection.execute(query: query) {queryResult in
                guard let resultSet = queryResult.asResultSet else {
                    completion(nil, HTTPStatusCode.serviceUnavailable)
                    return
                }
                for row in resultSet.rows {
                    feeds.append(Feed(row: row))
                }
            }
            guard let json = feeds.toJSONString(prettyPrint: true) else {
                completion(nil, HTTPStatusCode.badRequest)
                return
            }
            completion(json, nil)
        }
    }
}
