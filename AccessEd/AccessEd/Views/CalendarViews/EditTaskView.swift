//
//  EditTaskView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2025-01-24.
//

import SwiftUI

struct EditTaskView: View {
    @ObservedObject var viewModel: CalendarViewModel
    var taskIndex: Int
    @State private var taskName: String = ""
    @State private var taskDate: Date = Date()
    @Binding var isCurrentDateSelected: Bool
    @FocusState private var isTaskFieldFocused: Bool

    var body: some View {
        if viewModel.isEditingTask {
            Color.black.opacity(0.5) // Dim background
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.isEditingTask = false
                }
            
            VStack(spacing: 20) {
                Text("Edit Task")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color("Text-Colors"))
                
                if taskIndex >= 0 && taskIndex < (isCurrentDateSelected ? viewModel.tasksForCurrentDate.count: viewModel.tasksForSelectedDate.count) {
                    VStack(alignment: .leading) {
                        Text("Update Task Name")
                            .padding(.leading)
                        TextField("Enter Task Name", text: $taskName)
                            .focused($isTaskFieldFocused)
                            .padding(10)
                            .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                            .padding([.horizontal, .bottom], 20)
                            .font(.subheadline)
                        
                        Text("Update Due Date")
                            .padding(.leading)
                        DatePicker("Due Date", selection: $taskDate, displayedComponents: .date)
                            .padding(10)
                            .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                            .padding(.horizontal, 20)
                            .font(.subheadline)
                    }
                    .foregroundStyle(Color("Text-Colors"))
                }
                
                HStack(alignment: .center) {
                    // Cancel button
                    Button(action: {
                        viewModel.isEditingTask = false
                    }) {
                        Text("Cancel")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.red)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: 100, height: 40)
                                    .padding(.horizontal, 20)
                            )
                    }
                    
                    Spacer()
                    
                    // Save button
                    Button {
                        // Save the updated task
                        if taskIndex >= 0 && taskIndex < (isCurrentDateSelected ? viewModel.tasksForCurrentDate.count: viewModel.tasksForSelectedDate.count) {
                            viewModel.updateTaskName(at: taskIndex, with: taskName)
                            viewModel.updateTaskDate(at: taskIndex, with: taskDate)
                        }
                        viewModel.isEditingTask = false
                    } label: {
                        Text("Save")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                                    .frame(width: 100, height: 40)
                                    .padding(.horizontal, 20)
                            )
                    }
                }
                .padding(.trailing, 7)
                .frame(width: 250)
            }
            .padding()
            .frame(maxWidth: 350, maxHeight: 325)
            .padding(.top, 5)
            .background(
                Color("Courses-Colors")
                    .cornerRadius(15)
                    .shadow(radius: 1, x: 0, y: 1)
            )
            .padding(.horizontal, 10)
            .padding(.top, 10)
            .onAppear {
                if taskIndex >= 0 && taskIndex < (isCurrentDateSelected ? viewModel.tasksForCurrentDate.count: viewModel.tasksForSelectedDate.count) {
                    let task = isCurrentDateSelected ? viewModel.tasksForCurrentDate[taskIndex] : viewModel.tasksForSelectedDate[taskIndex]
                    taskName = task.name
                    taskDate = task.date
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTaskFieldFocused = true
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var isCurrentDateSelected: Bool = false
    let viewModel = CalendarViewModel()
    EditTaskView(viewModel: viewModel, taskIndex: 0, isCurrentDateSelected: $isCurrentDateSelected)
}
