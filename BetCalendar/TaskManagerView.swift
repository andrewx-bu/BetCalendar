//  TaskManagerView.swift
//  BetCalendar
//  Created by Andrew Xin on 7/5/24.

import SwiftUI
import SwiftData

struct TaskManagerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var tasks: [Task]
    @State private var path = [Task]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(tasks) { task in
                    NavigationLink(value: task) {
                        VStack(alignment: .leading) {
                            Text(task.name)
                                .font(.headline)
                            Text("Description: \(task.details)")
                            Text("Created on: \(task.createdAt.formatted(date: .abbreviated, time: .shortened))")
                            Text("Goal: \(task.goal)")
                            Text("Current Progress: \(task.currentProgress)")
                            Text("Deadline: \(task.deadline.formatted(date: .abbreviated, time: .omitted))")
                        }
                    }
                }
                .onDelete(perform: deleteTask)
            }
            .navigationTitle("Manage Tasks")
            .navigationDestination(for: Task.self, destination: EditTaskView.init)
            .toolbar {
                Button("Add Task", systemImage: "plus", action: addTask)
            }
        }
    }
    
    func addTask() {
        let task = Task()
        modelContext.insert(task)
        path = [task]
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
    return TaskManagerView()
        .modelContainer(container)
}
