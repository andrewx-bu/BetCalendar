//  Parlay.swift
//  BetCalendar
//  Created by Andrew Xin on 7/7/24.

import Foundation
import SwiftData

// A Parlay will be shown on the betslip as a collection of Bets.
@Model class Parlay: Identifiable {
    let id: UUID
    var wager: Double
    var odds: Double {          // Shown as a rounded integer to the User
        calculateOddsAndPayout(bets: bets.self, wager: wager.self).0
    }
    var payout: Double {        // Includes wager
        calculateOddsAndPayout(bets: bets.self, wager: wager.self).1
    }
    var status: Status
    var bets: [Bet]             // Array of Bet objects making this Parlay
    let createdAt: Date
    var settledAt: Date?
    
    enum Status: String, Codable {
        case active, won, lost
    }
    
    init(wager: Double = 5, status: Status = .active, bets: [Bet], createdAt: Date = .now, settledAt: Date? = nil) {
        self.id = UUID()
        self.wager = wager
        self.status = status
        self.bets = bets
        self.createdAt = createdAt
        self.settledAt = settledAt
    }
    
    func settleParlay(status: Status, settledAt: Date = .now) {
        self.status = status // won or lost
        self.settledAt = settledAt
    }
    
    // Tuple order: (Odds, Payout). Needs to be tested
    func calculateOddsAndPayout(bets: [Bet], wager: Double) -> (Double, Double) {
        var oddsArray: [Double] = []    // Odds converted from American to Decimal odds
        for bet in bets {
            var decimalOdds: Double
            if bet.odds > 0 {
                decimalOdds = Double((odds/100)) + 1
            } else {
                decimalOdds = -(Double(odds/100)) + 1
            }
            oddsArray.append(decimalOdds)
        }
        var decimalOdds = 1.0
        for odds in oddsArray {
            decimalOdds *= odds         // Parlay Decimal Odds
        }
        let payout = wager * decimalOdds
        var odds = 1.0
        if decimalOdds > 2 {
            odds = (decimalOdds - 1) * 100
        } else {
            odds = -100/(decimalOdds - 1)
        }
        return (odds, payout)
    }
}
