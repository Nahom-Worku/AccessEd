//
//  AddTaskSheetView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-19.
//

import SwiftUI

struct AddTaskSheetView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @FocusState private var isTaskFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add Task")
                .font(.title3)
                .bold()
                .foregroundStyle(Color("Text-Colors"))
            
            VStack (alignment: .leading) {
                Text("Add Task Name")
                    .padding(.leading)
                TextField("Enter Task Name", text: $calendarViewModel.TaskTitle)
                    .focused($isTaskFieldFocused)
                    .padding(10)
                    .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                    .padding([.horizontal, .bottom], 20)
                    .font(.subheadline)
            
                Text("Select Date")
                    .padding(.leading)
                DatePicker("Due Date", selection: $calendarViewModel.selectedDate, displayedComponents: .date)
                    .padding(10)
                    .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                    .padding([.horizontal, .bottom], 20)
                    .font(.subheadline)
                
                Text("Select Time")
                    .padding(.leading)
                DatePicker("Due Time", selection: $calendarViewModel.dueTime, displayedComponents: .hourAndMinute)
                    .padding(10)
                    .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                    .padding(.horizontal, 20)
                    .font(.subheadline)
            }
            .foregroundStyle(Color("Text-Colors"))

            
            HStack(alignment: .center) {
                
                // canel bottom sheet button
                Button(action: { calendarViewModel.isAddingTask = false }) {
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
                
                // Add course button
                Button(action: {
                    calendarViewModel.addTask(for: calendarViewModel.selectedDate, time: calendarViewModel.dueTime, name: calendarViewModel.TaskTitle)
                    scheduleTasksNotification(taskTitle: calendarViewModel.TaskTitle, dueDate: calendarViewModel.selectedDate, dueTime: calendarViewModel.dueTime)
                    calendarViewModel.dueTime = Date()
                    calendarViewModel.TaskTitle = ""
                    calendarViewModel.isAddingTask = false
                }, label: {
                    Text("Add")
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
                })
                .disabled(calendarViewModel.TaskTitle.isEmpty)
            }
            .padding(.trailing, 7)
            .frame(width: 250)
        }
        .padding()
        .frame(maxWidth: 350, maxHeight: 650)
        .padding(.top, 5)
        .background(
            Color("Courses-Colors")
                .cornerRadius(15)
                .shadow(radius: 1, x: 0, y: 1)
        )
        .padding(.horizontal, 10)
        .padding(.top, 10)
        .onAppear {
            profileViewModel.fetchProfile()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTaskFieldFocused = true
            }
        }
    }
    
    func scheduleTasksNotification(taskTitle: String, dueDate: Date, dueTime: Date) {
        guard profileViewModel.profile?.isNotificationsOn == true else {
            print("Notifications are turned off.")
            return
        }
        
        let identifier = "TasksReminder_\(taskTitle)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: dueTime)
        let minute = calendar.component(.minute, from: dueTime)
        let taskDueAt = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: dueDate)!

        NotificationManager.shared.scheduleNotification(
            at: taskDueAt,
            title: "Tasks Reminder ⏰",
            body: "Hi \(profileViewModel.profile?.name ?? "there"), it's time to complete '\(taskTitle)' task. Don't forget to mark it as done!",
            identifier: identifier
        )
    }
}

