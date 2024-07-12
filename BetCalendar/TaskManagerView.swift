//  TaskManagerView.swift
//  BetCalendar
//  Created by Andrew Xin on 7/5/24.

import SwiftUI
import SwiftData

struct TaskManagerView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var path = [Task]()
    @State private var sortOrder = SortDescriptor(\Task.name)
    @Query var tasks: [Task]
    
    // Sort by various methods
    var sortedTasks: [Task] {
        tasks.sorted(by: { task1, task2 in
            switch sortOrder {
            case SortDescriptor(\Task.name):
                return task1.name < task2.name
            case SortDescriptor(\Task.priority):
                return task1.priority < task2.priority
            case SortDescriptor(\Task.progress):
                let ratio1 = task1.goal == 0 ? 0 : Double(task1.progress) / Double(task1.goal)
                let ratio2 = task2.goal == 0 ? 0 : Double(task2.progress) / Double(task2.goal)
                return ratio1 > ratio2
            case SortDescriptor(\Task.createdAt):
                return task1.createdAt < task2.createdAt
            case SortDescriptor(\Task.deadline):
                return task1.deadline < task2.deadline
            default:
                return task1.name < task2.name
            }
        })
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(sortedTasks) { task in
                    ZStack(alignment: .topTrailing) {
                        NavigationLink(value: task) {
                            HStack {
                                VStack {
                                    Spacer()
                                    Button(action: {
                                        guard task.progress < task.goal else { return }
                                        task.progress += 1
                                    }) {
                                        Image(systemName: "plus.circle")
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    Spacer()
                                    // Make this red if deadline has passed and the task still isn't completed
                                    Text("\(task.progress)/\(task.goal)")
                                        .font(.footnote)
                                        .foregroundColor(task.isCompleted ? .green : .primary)
                                    Spacer()
                                    Button(action: {
                                        guard task.progress > 0 else { return }
                                        task.progress -= 1
                                    }) {
                                        Image(systemName: "minus.circle")
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    Spacer()
                                }
                                Divider().frame(width: 1)
                                VStack(alignment: .leading) {
                                    HStack(spacing: 10) {
                                        prioritySymbol(for: task.priority)
                                            .font(.footnote)
                                        Text(task.name)
                                            .font(.headline)
                                    }
                                    if !task.details.trimmed().isEmpty {
                                        Text(task.details)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(3)
                                            .truncationMode(.tail)
                                    }
                                    Grid(alignment: .leading) {
                                        GridRow {
                                            Text("Created:")
                                                .font(.footnote)
                                                .frame(width: 60, alignment: .leading)
                                            Text(task.createdAt.relativeString)
                                                .font(.footnote)
                                        }
                                        GridRow {
                                            Text("Deadline:")
                                                .font(.footnote)
                                                .frame(width: 60, alignment: .leading)
                                            Text(task.deadline.relativeString)
                                                .font(.footnote)
                                                .foregroundColor(deadlineColor(for: task.deadline))
                                        }
                                    }
                                }
                            }
                        }
                        // Add red exclamation if past deadline
                        if !task.isCompleted && task.deadline.timeIntervalSinceNow <= 12 * 60 * 60 {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(.orange)
                                .padding(.top, 10)
                                .padding(.trailing, -5)
                        } else if task.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .padding(.top, 10)
                                .padding(.trailing, -5)
                        }
                    }
                }
                .onDelete(perform: deleteTask)
            }
            .navigationTitle("Manage Tasks")
            .navigationDestination(for: Task.self, destination: EditTaskView.init)
            .toolbar {
                Button(action: addTask) {
                    Label("Add Task", systemImage: "plus")
                }
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Name")
                            .tag(SortDescriptor(\Task.name))
                        Text("Priority")
                            .tag(SortDescriptor(\Task.priority))
                        Text("Progress")
                            .tag(SortDescriptor(\Task.progress))
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
    
    func deleteTask(_ indexSet: IndexSet) {
        for index in indexSet {
            let task = tasks[index]
            modelContext.delete(task)
        }
    }
    
    func addTask() {
        let task = Task()
        modelContext.insert(task)
        path = [task]
    }
    
    func deadlineColor(for deadline: Date) -> Color {
        let timeInterval = deadline.timeIntervalSinceNow
        let oneDay: TimeInterval = 60 * 60 * 24
        let halfWeek: TimeInterval = 3.5 * oneDay
        if timeInterval < oneDay/2 {
            return .red
        } else if timeInterval < halfWeek {
            return .orange
        } else {
            return .gray
        }
    }
    
    func priorityText(for priority: Int) -> String {
        switch priority {
        case 1:
            return "High"
        case 2:
            return "Medium"
        default:
            return "Low"
        }
    }
    
    // Add color
    func prioritySymbol(for priority: Int) -> Image {
        switch priority {
        case 1:
            return Image(systemName: "exclamationmark.triangle.fill")
        case 2:
            return Image(systemName: "bolt.fill")
        default:
            return Image(systemName: "chevron.down.circle.fill")
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
