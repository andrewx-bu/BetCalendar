//  TaskListingView.swift
//  BetCalendar
//  Created by Andrew Xin on 7/8/24.

import SwiftUI
import SwiftData

struct TaskListingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var tasks: [Task]
    
    var body: some View {
        List {
            ForEach(tasks) { task in
                NavigationLink(value: task) {
                    VStack(alignment: .leading) {
                        Text(task.name)
                            .font(.headline)
                        // If description is empty, will hide
                        if !task.details.trimmed().isEmpty {
                            Text(task.details)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Text("Goal: \(task.goal)")
                            .font(.footnote)
                        Text("Current Progress: \(task.currentProgress)")
                            .font(.footnote)
                        Text("Created on: \(task.createdAt.formatted(date: .abbreviated, time: .shortened))")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        Text("Deadline: \(task.deadline.formatted(date: .abbreviated, time: .omitted))")
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }
            }
            .onDelete(perform: deleteTask)
        }
    }
    
    init(sort: SortDescriptor<Task>) {
        _tasks = Query(sort: [sort])
    }
    
    func deleteTask(_ indexSet: IndexSet) {
        for index in indexSet {
            let task = tasks[index]
            modelContext.delete(task)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Task.self, configurations: config)
    for i in 1...3 {
        let task = Task(name: "Task \(i)")
        container.mainContext.insert(task)
    }
    return TaskListingView(sort: SortDescriptor(\Task.name))
        .modelContainer(container)
}
