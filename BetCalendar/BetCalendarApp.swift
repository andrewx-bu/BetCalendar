//  BetCalendarApp.swift
//  BetCalendar
//  Created by Andrew Xin on 7/4/24.

import SwiftUI
import SwiftData

@main
struct BetCalendarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Task.self)
    }
}
