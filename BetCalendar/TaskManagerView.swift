//
//  TaskManagerView.swift
//  BetCalendar
//
//  Created by Andrew Xin on 7/5/24.
//

import SwiftUI
import SwiftData

struct TaskManagerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var tasks: [Task]
    
    var body: some View {
        List {
            ForEach(tasks) { task in
                VStack(alignment: .leading) {
                    Text(task.name)
                        .font(.headline)
                    Text("Description: \(task.descriptor)")
                    Text("Created on: \(task.createdAt.formatted(date: .abbreviated, time: .shortened))")
                    Text("Goal: \(task.goal)")
                    Text("Current Progress: \(task.currentProgress)")
                }
            }
            .onDelete(perform: deleteTask)
        }
        .navigationTitle("Manage Tasks")
    }
    
    func deleteTask(_ indexSet: IndexSet) {
        for index in indexSet {
            let task = tasks[index]
            modelContext.delete(task)
        }
    }
}

#Preview {
    TaskManagerView()
}
