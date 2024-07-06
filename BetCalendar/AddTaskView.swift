//  AddTaskView.swift
//  BetCalendar
//  Created by Andrew Xin on 7/4/24.

import SwiftUI
import SwiftData

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Query var tasks: [Task]
    
    @State private var taskName = ""
    @State private var descriptor = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Task Name", text: $taskName)
            }
            Section("Task Details") {
                TextEditor(text: $descriptor)
            }
        }
    }
}

#Preview {
    AddTaskView()
}
