//  ContentView.swift
//  BetCalendar
//  Created by Andrew Xin on 7/4/24.

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var tasks: [Task]
    @State private var addingTask = false
    
    var body: some View {
        NavigationStack {
            TaskManagerView()
                .navigationTitle("BetCalendar")
                .toolbar {
                    Button("Add Sample") {
                        let task1 = Task(name: "Do the Dishes", goal: 2)
                        let task2 = Task(name: "Work on Swift Project", descriptor: "Finish Bet & Parlay Classes")
                        modelContext.insert(task1)
                        modelContext.insert(task2)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
