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
}
