//  Extensions.swift
//  BetCalendar
//  Created by Andrew Xin on 7/8/24.

import Foundation

extension String {
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    mutating func trim() {
        self = trimmed()
    }
}

extension Date {
    var relativeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: .now)
    }
    
    var nearest15MinuteInterval: Date {
        let calendar = Calendar.current
        let next15Minutes = calendar.date(byAdding: .minute, value: 15 - calendar.component(.minute, from: .now) % 15, to: .now)!
        return next15Minutes
    }
}
