//
//  Date+ext.swift
//  DeliHood
//
//  Created by Vojta Fluger on 21.08.2025.
//

import Foundation

extension Date {
    func timeAgoOrDate() -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            let diff = Int(Date().timeIntervalSince(self))
            if diff < 60 {
                return "Just now"
            } else if diff < 3600 {
                return "\(diff / 60) min ago"
            } else {
                return "\(diff / 3600) h ago"
            }
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            let customFormatter = DateFormatter()
            customFormatter.dateFormat = "dd. MM"
            return customFormatter.string(from: self)
        }
    }
}
