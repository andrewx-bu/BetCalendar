//  Bet.swift
//  BetCalendar
//  Created by Andrew Xin on 7/4/24.

import Foundation
import SwiftData

// A Bet will be shown as an odds value button.
@Model class Bet: Identifiable {
    let id: UUID
    var wager: Double
    var odds: Int
    var payout: Double {    // Includes wager
        calculatePayout(odds: self.odds, wager: self.wager)
    }
    var status: Status
    let task: Task          // This Task is linked to this Bet object
    let createdAt: Date
    var settledAt: Date?
    
    enum Status: String, Codable {
        case active, won, lost
    }
    
    init(wager: Double = 5, odds: Int = -110, status: Status = .active, task: Task, createdAt: Date = .now, settledAt: Date? = nil) {
        self.id = UUID()
        self.wager = wager
        self.odds = odds
        self.status = status
        self.task = task
        self.createdAt = createdAt
        self.settledAt = settledAt
    }
    
    func settleBet(status: Status, settledAt: Date = .now) {
        self.status = status // won or lost
        self.settledAt = settledAt
    }
    
    // Needs to be tested
    func calculatePayout(odds: Int, wager: Double) -> Double {
        var convertedOdds: Double
        if odds > 0 {
            convertedOdds = (Double(odds/100)) + 1
        } else {
            convertedOdds = -(Double(odds/100)) + 1
        }
        return convertedOdds * wager
    }
}
