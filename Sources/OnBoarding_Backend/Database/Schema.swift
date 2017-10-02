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
