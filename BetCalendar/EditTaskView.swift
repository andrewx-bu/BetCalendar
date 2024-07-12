//  EditTaskView.swift
//  BetCalendar
//  Created by Andrew Xin on 7/7/24.

import SwiftUI
import SwiftData

struct EditTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var task: Task
    @State private var originalTask: Task?
    
    var body: some View {
        Form {
            Section("Task Name and Details") {
                TextField("Task Name", text: $task.name)
                    .onChange(of: task.name) { newValue in
                        if newValue.count > 25 {
                            task.name = String(newValue.prefix(25))
                        }
                    }
                TextEditor(text: $task.details)
                    .onChange(of: task.name) { newValue in
                        if newValue.count > 75 {
                            task.name = String(newValue.prefix(75))
                        }
                    }
            }
            Section("Priority") {
                Picker("Priority", selection: $task.priority) {
                    Text("High").tag(1)
                    Text("Medium").tag(2)
                    Text("Low").tag(3)
                }
                .pickerStyle(.segmented)
            }
            Section("Repetitions for this Task") {
                Stepper("Goal: \(task.goal)", value: $task.goal, in: 1...50)
                Stepper("Progress: \(task.progress)", value: $task.progress, in: 0...task.goal)
            }
            Section {
                DatePicker("Deadline", selection: $task.deadline, in: Date().nearest15MinuteInterval...)
            }
        }
        // Create a copy of the task. If edits are cancelled, will revert to original
        .onAppear {
            if originalTask == nil {
                originalTask = task.copy()
            }
        }
        .navigationTitle("Edit Task")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItemGroup(placement: .cancellationAction) {
                Button("Cancel") {
                    if let originalTask = originalTask {
                        task.name = originalTask.name
                        task.details = originalTask.details
                        task.priority = originalTask.priority
                        task.goal = originalTask.goal
                        task.progress = originalTask.progress
                        task.deadline = originalTask.deadline
                    }
                    if task.name.trimmed().isEmpty {
                        modelContext.delete(task)
                    }
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { dismiss() }
                    .disabled(!hasChanges())
            }
        }
    }
    
    private func hasChanges() -> Bool {
        guard let originalTask = originalTask else { return false }
        return task.name != originalTask.name ||
        task.details != originalTask.details ||
        task.priority != originalTask.priority ||
        task.goal != originalTask.goal ||
        task.progress != originalTask.progress ||
        task.deadline != originalTask.deadline
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Task.self, configurations: config)
    let example = Task(name: "Example Task", details: "Example Details")
    return EditTaskView(task: example)
        .modelContainer(container)
}
