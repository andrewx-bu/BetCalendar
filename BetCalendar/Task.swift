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
    
    enum CodingKeys: String, CodingKey {
        case id, name, details, goal, currentProgress, createdAt, deadline
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        details = try container.decode(String.self, forKey: .details)
        goal = try container.decode(Int.self, forKey: .goal)
        currentProgress = try container.decode(Int.self, forKey: .currentProgress)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        deadline = try container.decode(Date.self, forKey: .deadline)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(details, forKey: .details)
        try container.encode(goal, forKey: .goal)
        try container.encode(currentProgress, forKey: .currentProgress)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(deadline, forKey: .deadline)
    }
    
    // Creates a deep copy
    func copy() -> Task {
        return Task(name: name, details: details, goal: goal, currentProgress: currentProgress, createdAt: createdAt, deadline: deadline)
    }
}
