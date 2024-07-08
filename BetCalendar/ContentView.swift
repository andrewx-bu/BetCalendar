//  ContentView.swift
//  BetCalendar
//  Created by Andrew Xin on 7/4/24.

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TaskManagerView()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Task.self, configurations: config)
    for _ in 1...3 {
        let task = Task(name: "Example Task", details: "Example Details")
        container.mainContext.insert(task)
    }
    return ContentView()
        .modelContainer(container)
}
