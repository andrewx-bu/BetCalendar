//  Bet.swift
//  BetCalendar
//  Created by Andrew Xin on 7/4/24.

import Foundation
import SwiftData

@Model class Bet {
    let id: UUID
    var descriptor: String
    var wager: Double
    var odds: [Int]
    var status: BetStatus
    let createdAt: Date
    var settledAt: Date?
    
    enum BetStatus: String, Codable {
        case active, won, lost
    }
    
    init(descriptor: String = "", wager: Double = 5, odds: [Int] = [-110, -110], status: BetStatus = .active, createdAt: Date = .now, settledAt: Date? = nil) {
        self.id = UUID()
        self.descriptor = descriptor
        self.wager = wager
        self.odds = odds
        self.status = status
        self.createdAt = createdAt
        self.settledAt = settledAt
    }
    
    func settleBet(status: BetStatus, settledAt: Date = .now) {
        self.status = status
        self.settledAt = settledAt
    }
}
