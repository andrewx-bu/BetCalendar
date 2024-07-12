//  Task.swift
//  BetCalendar
//  Created by Andrew Xin on 7/4/24.

import Foundation
import SwiftData

// A Task represents a goal for the day.
@Model class Task: Identifiable, Codable {
    let id: UUID
    var name: String
    var details: String
    var priority: Int           // 1: high, 2: medium, 3: low
    var goal: Int               // Represents the amount of repetitions for that goal
    var progress: Int           // Amount of repetitions finished
    var isCompleted: Bool {
        return progress >= goal
    }
    var createdAt: Date
    var deadline: Date
    
    init(name: String = "", details: String = "", priority: Int = 2, goal: Int = 1, progress: Int = 0, createdAt: Date = .now, deadline: Date = Date().nearest15MinuteInterval) {
        self.id = UUID()
        self.name = name
        self.details = details
        self.priority = priority
        self.goal = goal
        self.progress = progress
        self.createdAt = createdAt
        self.deadline = deadline
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, details, priority, goal, progress, createdAt, deadline
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        details = try container.decode(String.self, forKey: .details)
        priority = try container.decode(Int.self, forKey: .priority)
        goal = try container.decode(Int.self, forKey: .goal)
        progress = try container.decode(Int.self, forKey: .progress)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        deadline = try container.decode(Date.self, forKey: .deadline)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(details, forKey: .details)
        try container.encode(priority, forKey: .priority)
        try container.encode(goal, forKey: .goal)
        try container.encode(progress, forKey: .progress)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(deadline, forKey: .deadline)
    }
    
    // Creates a deep copy
    func copy() -> Task {
        return Task(name: name, details: details, priority: priority, goal: goal, progress: progress, createdAt: createdAt, deadline: deadline)
    }
}
