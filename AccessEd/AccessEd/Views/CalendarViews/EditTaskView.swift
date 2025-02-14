//
//  EditTaskView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2025-01-24.
//

import SwiftUI

struct EditTaskView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    var taskIndex: Int
    @State private var taskTitle: String = ""
    @State private var taskDate: Date = Date()
    @State private var taskDueTime: Date = Date()
    @Binding var isCurrentDateSelected: Bool
    @FocusState private var isTaskFieldFocused: Bool

    var body: some View {
        if calendarViewModel.isEditingTask {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    calendarViewModel.isEditingTask = false
                }
            
            VStack(spacing: 20) {
                Text("Edit Task")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color("Text-Colors"))
                
                if taskIndex >= 0 && taskIndex < (isCurrentDateSelected ? calendarViewModel.tasksForCurrentDate.count: calendarViewModel.tasksForSelectedDate.count) {
                    VStack(alignment: .leading) {
                        Text("Update Task Name")
                            .padding(.leading)
                        TextField("Enter Task Name", text: $taskTitle)
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
                        
                        Text("Update Due Time")
                            .padding(.leading)
                        DatePicker("Due Time", selection: $taskDueTime, displayedComponents: .hourAndMinute)
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
                        calendarViewModel.isEditingTask = false
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
                        if taskIndex >= 0 && taskIndex < (isCurrentDateSelected ? calendarViewModel.tasksForCurrentDate.count: calendarViewModel.tasksForSelectedDate.count) {
                            let task = isCurrentDateSelected ? calendarViewModel.tasksForCurrentDate[taskIndex] : calendarViewModel.tasksForSelectedDate[taskIndex]
                            let originalTaskName = task.name
                            
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["TasksReminder_\(originalTaskName)"])
                            calendarViewModel.updateTask(at: taskIndex, newName: taskTitle, newDate: taskDate, dueTime: taskDueTime)
                            profileViewModel.scheduleTasksNotification(taskTitle: taskTitle, dueDate: taskDate, dueTime: taskDueTime)
                        }
                        calendarViewModel.isEditingTask = false
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
            .frame(maxWidth: 350, maxHeight: 450)
            .padding(.top, 5)
            .background(
                Color("Courses-Colors")
                    .cornerRadius(15)
                    .shadow(radius: 1, x: 0, y: 1)
            )
            .padding(.horizontal, 10)
            .padding(.top, 10)
            .onAppear {
                if taskIndex >= 0 && taskIndex < (isCurrentDateSelected ? calendarViewModel.tasksForCurrentDate.count: calendarViewModel.tasksForSelectedDate.count) {
                    let task = isCurrentDateSelected ? calendarViewModel.tasksForCurrentDate[taskIndex] : calendarViewModel.tasksForSelectedDate[taskIndex]
                    taskTitle = task.name
                    taskDate = task.date
                    taskDueTime = task.time
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
    let calendarViewModel = CalendarViewModel()
    let profileViewModel = ProfileViewModel()
    EditTaskView(calendarViewModel: calendarViewModel, profileViewModel: profileViewModel, taskIndex: 0, isCurrentDateSelected: $isCurrentDateSelected)
}
