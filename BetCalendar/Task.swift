//  Task.swift
//  BetCalendar
//  Created by Andrew Xin on 7/4/24.

import Foundation
import SwiftData

@Model class Task {
    let id: UUID
    var name: String
    var descriptor: String
    var goal: Int
    var currentProgress: Int
    var createdAt: Date
    
    init(name: String, descriptor: String = "", goal: Int = 1, currentProgress: Int = 0, createdAt: Date = .now) {
        self.id = UUID()
        self.name = name
        self.descriptor = descriptor
        self.goal = goal
        self.currentProgress = currentProgress
        self.createdAt = createdAt
    }
}
