//
//  Date+Extension.swift
//  GHFollowers
//
//  Created by Jervy Umandap on 7/23/24.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func convertToMonthYearFormatNew() -> String {
        return formatted(.dateTime.month().year())
    }
}

/// TEST MODEL
struct People: Codable {
    let name: String
    let location: String
    let bdate: Date
    let age: Int
    
    init(name: String, location: String = "", bdate: Date, age: Int = 0) {
        self.name = name
        self.location = location
        self.bdate = bdate
        self.age = age
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.bdate, forKey: .bdate)
        try container.encode(self.age, forKey: .age)
    }
    
    enum CodingKeys: CodingKey {
        case name
        case location
        case bdate
        case age
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.location = try container.decode(String.self, forKey: .location)
        self.bdate = try container.decode(Date.self, forKey: .bdate)
        self.age = try container.decode(Int.self, forKey: .age)
    }
}
