import Kitura
import SwiftKueryMySQL
import SwiftKuery

class AssociateT: Table {
    let tableName = "associate"
    let identifier = Column("identifier")
    let email = Column("email")
    let name = Column("name")
    let password = Column("password")
}

class FeedT: Table {
    let tableName = "feed"
    let title = Column("title")
    let description = Column("description")
    let details = Column("details")
    let date = Column("date")
}
