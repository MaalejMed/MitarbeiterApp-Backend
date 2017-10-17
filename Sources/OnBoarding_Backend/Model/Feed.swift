//
//  Feed.swift
//  OnBoarding_BackendPackageDescription
//
//  Created by mmaalej on 04/10/2017.
//

import SwiftKuery
import Foundation
import SwiftKueryMySQL
import ObjectMapper

struct Feed: Mappable {
    
    //MARK:- Properties
    var identifier: String?
    var title: String?
    var description: String?
    var details: String?
    var date: Date?
    
    init(row: [Any?]) {
        title = row[0] as? String ?? ""
        description = row[1] as? String ?? ""
        details = row[2] as? String ?? ""
        let dateString = row[3] as? String ?? nil
        date = dateString?.simpleDateFormat()
    }
    
    //MARK:- mappable
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        details <- map["details"]

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date <- (map["date"], DateFormatterTransform(dateFormatter: dateFormatter))
    }
}
