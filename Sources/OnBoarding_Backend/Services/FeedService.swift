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
        router.get("/feed") { [unowned self] request, response, next in
            let feedManager = FeedManager(router: self.router, connection: self.connection)
            feedManager.fetch(completion: { feedJson, failure in
                guard let feeds = feedJson else {
                    response.send("\(failure!.rawValue)")
                    return
                }
                response.send(feeds)
                next()
            })
        }
    }
}
