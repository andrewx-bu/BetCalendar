//  TaskManagerView.swift
//  BetCalendar
//  Created by Andrew Xin on 7/5/24.

import SwiftUI
import SwiftData

struct TaskManagerView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var path = [Task]()
    @State private var sortOrder = SortDescriptor(\Task.name)
    
    var body: some View {
        NavigationStack(path: $path) {
            TaskListingView(sort: sortOrder)
                .navigationTitle("Manage Tasks")
                .navigationDestination(for: Task.self, destination: EditTaskView.init)
                .toolbar {
                    Button(action: addTask) {
                        Label("Add Task", systemImage: "plus")
                    }
                    Menu("sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Name")
                                .tag(SortDescriptor(\Task.name))
                            // Sort by how currentProgress/goal. Goals close to finished are listed first. Implementation is wrong as of now.
                            Text("Progress")
                                .tag(SortDescriptor(\Task.currentProgress))
                            Text("Date Created")
                                .tag(SortDescriptor(\Task.createdAt))
                            Text("Deadline")
                                .tag(SortDescriptor(\Task.deadline))
                        }
                        .pickerStyle(.inline)
                    }
                }
        }
    }
    
    func addTask() {
        let task = Task()
        modelContext.insert(task)
        path = [task]
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
