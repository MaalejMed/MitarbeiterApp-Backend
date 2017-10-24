import Kitura
import SwiftKueryMySQL
import SwiftKuery

class AssociateT: Table {
    let tableName = "associate"
    let identifier = Column("identifier")
    let email = Column("email")
    let name = Column("name")
    let password = Column("password")
    let photo = Column("photo")
}

class FeedT: Table {
    let tableName = "feed"
    let title = Column("title")
    let description = Column("description")
    let details = Column("details")
    let date = Column("date")
}

class TimeT: Table {
    let tableName = "time"
    let associateID = Column("associateID")
    let day = Column("day")
    let projectID = Column("projectID")
    let activity = Column("activity")
    let billable = Column("billable")
    let workFrom = Column("workFrom")
    let workUntil = Column("workUntil")
    let workedHours = Column("workedHours")
    let lunchBreak = Column("lunchBreak")
}

class MessageT: Table {
    let tableName = "message"
    let associateID = Column("associateID")
    let title = Column("title")
    let body = Column("body")
    let date = Column("date")
    let identifier = Column("identifier")
    let hasResponse = Column("hasResponse")
}

class MessageResponseT: Table {
    let tableName = "messageResponse"
    let identifier = Column("identifier")
    let body = Column("body")
    let date = Column("date")
    let messageID = Column("messageID")
}
