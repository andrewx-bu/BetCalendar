//  Task.swift
//  BetCalendar
//  Created by Andrew Xin on 7/4/24.

import Foundation
import SwiftData

// A Task represents a goal for the day.
@Model class Task: Identifiable {
    let id: UUID
    var name: String
    var details: String
    var goal: Int               // Represents the amount of repetitions for that goal
    var currentProgress: Int
    var createdAt: Date
    var deadline: Date
    
    init(name: String = "", details: String = "", goal: Int = 1, currentProgress: Int = 0, createdAt: Date = .now, deadline: Date = .now.addingTimeInterval(86400)) {
        self.id = UUID()
        self.name = name
        self.details = details
        self.goal = goal
        self.currentProgress = currentProgress
        self.createdAt = createdAt
        self.deadline = deadline
    }
}
