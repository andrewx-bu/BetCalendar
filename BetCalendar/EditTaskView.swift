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
            Section("Enter Task and details") {
                TextField("Task Name", text: $task.name)
                TextField("Details", text: $task.details, axis: .vertical)
            }
            Section("Repetitions for this Task") {
                Stepper("Goal: \(task.goal)", value: $task.goal, in: 1...50)
                Stepper("Current Progress: \(task.currentProgress)", value: $task.currentProgress, in: 0...50)
            }
            Section {
                DatePicker("Deadline", selection: $task.deadline, displayedComponents: .date)
            }
        }
        // Create a copy of the task. If edits are cancelled, will revert to original
        .onAppear {
            if originalTask == nil {
                originalTask = try? JSONDecoder().decode(Task.self, from: JSONEncoder().encode(task))
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
                        task.goal = originalTask.goal
                        task.currentProgress = originalTask.currentProgress
                        task.deadline = originalTask.deadline
                    }
                    if task.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
        task.goal != originalTask.goal ||
        task.currentProgress != originalTask.currentProgress ||
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
