//
//  CalendarViewModel.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-16.
//

import Foundation
import SwiftData
import SwiftUI

class CalendarViewModel : ObservableObject {
    @Published var currentMonth: Date = Date()
    @Published var selectedDate: Date = Date()
    @Published var dueTime: Date = Date()
    @Published var tasks: [TaskModel] = []
    @Published var fetchedTasks: [TaskModel] = []
    @Published var allTasksCompletedByDate: [Date: Bool] = [:]
    @Published var isAddingTask: Bool = false
    @Published var isEditingTask: Bool = false
    @Published var TaskTitle: String = ""
    @Published var newTaskDescription: String = ""
    @Published var selectedTaskIndex: Int?
    @Published var taskAlerts: TaskAlerts? = nil
    @Published var taskToDelete: TaskModel?
    // CalendarModel for dynamic colors (Optional)
    @Published var calendarDates: [CalendarModel] = []
 
    @Published var showTaskActions: Bool = false
    var modelContext: ModelContext? = nil
    var calendar = Calendar.current

    // Filter tasks for the selected date
    var tasksForSelectedDate: [TaskModel] { tasks.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) } }
    
    var tasksForCurrentDate: [TaskModel] { tasks.filter { calendar.isDateInToday($0.date) } }
    
    var uncompletedTasks: [TaskModel] { tasks.filter { !$0.isCompleted } }
    
    // Filter the uncompleted tasks for the selected date
    var uncompletedTasksForSelectedDate: [TaskModel] { tasksForSelectedDate.filter { !$0.isCompleted } }
    
    var uncompletedTasksForCurrentDate: [TaskModel] { tasks.filter { calendar.isDateInToday($0.date) && !$0.isCompleted }}
    
    let soundPlayer = SoundPlayer()
    
    var daysInMonthWithPadding: [Date?] {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))
        guard let startOfMonth = startOfMonth,
              let range = calendar.range(of: .day, in: .month, for: startOfMonth),
              let firstDayOfWeek = calendar.dateComponents([.weekday], from: startOfMonth).weekday else {
            return []
        }
        
        let padding = Array<Date?>(repeating: nil, count: firstDayOfWeek - 1)
        let days = range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
        return padding + days
    }
    
    var onDateSelected: ((Date) -> Void)?
    var updateDynamicColor: ((Date) -> Void)?
    
    
//    func fetchTasks() {
//        guard let context = modelContext else { return }
//        let fetchDescriptor = FetchDescriptor<TaskModel>(sortBy: [SortDescriptor(\.time)])
//        tasks = (try? context.fetch(fetchDescriptor)) ?? []
//    }
    
    func fetchTasks() {
        guard let context = modelContext else { return }

        let now = Date()
        let calendar = Calendar.current

        let fetchDescriptor = FetchDescriptor<TaskModel>(
            sortBy: [SortDescriptor(\.time, order: .forward)] // Fetch tasks sorted by time
        )

        tasks = (try? context.fetch(fetchDescriptor)) ?? []

        // Reorder tasks to ensure:
        // - Closest upcoming tasks appear at the top
        // - Tasks with due times that have already passed appear at the bottom
        tasks.sort { task1, task2 in
            let nowInMinutes = calendar.component(.hour, from: now) * 60 + calendar.component(.minute, from: now)

            let time1 = calendar.dateComponents([.hour, .minute], from: task1.time)
            let time2 = calendar.dateComponents([.hour, .minute], from: task2.time)

            let time1InMinutes = time1.hour! * 60 + time1.minute!
            let time2InMinutes = time2.hour! * 60 + time2.minute!

            let task1Passed = time1InMinutes < nowInMinutes
            let task2Passed = time2InMinutes < nowInMinutes

            // If one task is past due and the other is not, move the past due one to the bottom
            if task1Passed != task2Passed {
                return !task1Passed
            }

            // Otherwise, sort by proximity to current time
            return abs(time1InMinutes - nowInMinutes) < abs(time2InMinutes - nowInMinutes)
        }
    }

    
    func fetchCalendarDates() {
        let fetchDescriptor = FetchDescriptor<CalendarModel>(
            sortBy: [SortDescriptor(\.date)]
        )
        calendarDates = (try? (modelContext?.fetch(fetchDescriptor) ?? [])) ?? []
        
        fetchTasks()
    }
    
    func addTask(for date: Date, time: Date, name: String) {
        guard let context = modelContext, !name.isEmpty else { return }
        let newTask = TaskModel(date: date, time: time, name: name, isCompleted: false)
        context.insert(newTask)
        try? context.save()
        fetchTasks()
    }
    
    func completeAllTasks(for date: Date) {
        guard let context = modelContext else { return }
        let tasksToComplete = tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
        let wereAllTasksCompleted = tasksToComplete.allSatisfy { $0.isCompleted }
        
        for task in tasksToComplete {
            task.isCompleted = true
        }
        try? context.save()
        fetchTasks()
        
        let areAllTasksCompleted = tasksToComplete.allSatisfy { $0.isCompleted }

        if areAllTasksCompleted && !wereAllTasksCompleted {
            soundPlayer.playSound(named: "All_tasks_completed.mp3", volume: 0.025)
        }
    }
    
    func deleteTask(_ task: TaskModel) {
        guard let context = modelContext else { return }
        context.delete(task) // Remove task from the model context
        try? context.save()  // Save the context to persist changes
        fetchTasks()
        
        soundPlayer.playSound(named: "All_Task_deleted.mp3", volume: 0.2)
    }
    
    func deleteAllTasks(for date: Date) {
        guard let context = modelContext else { return }
        let tasksToDelete = tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
        for task in tasksToDelete {
            context.delete(task)
        }
        try? context.save()
        fetchTasks()
        
        soundPlayer.playSound(named: "All_Task_deleted.mp3", volume: 0.2)
    }
    
    func DeleteAllTasks() {
        guard let context = modelContext else { return }
        for task in tasks {
            context.delete(task)
        }
        
        try? context.save()
        fetchTasks()
    }
    
    func updateAllTasksCompleted() {
        var completionStatus: [Date: Bool] = [:]

        for task in tasks {
            let taskDate = calendar.startOfDay(for: task.date) // Normalize to the start of the day
            let tasksForDate = tasks.filter { calendar.isDate($0.date, inSameDayAs: taskDate) }
            completionStatus[taskDate] = tasksForDate.allSatisfy { $0.isCompleted }
        }

        allTasksCompletedByDate = completionStatus
        fetchTasks()
    }
    
    func updateTask(at index: Int, newName: String, newDate: Date, dueTime: Date) {
        guard index >= 0, index < tasksForSelectedDate.count else { return }
        
        let task = tasksForSelectedDate[index]
        task.name = newName
        task.date = newDate
        task.time = dueTime
        
        try? modelContext?.save()
        fetchTasks()
    }

    func handleTaskCompletion(_ task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle() // Toggle completion
            if tasks[index].isCompleted {
                soundPlayer.playSound(named: "Task_completed.mp3", volume: 0.2)
            } else {
                soundPlayer.playSound(named: "Task_uncompleted.mp3", volume: 0.02)
            }
            updateAllTasksCompleted() // Update other state
        }
    }

    
    func updateDynamicColor(for date: Date) {
        // Check task state for the date
        let hasTasks = tasks.contains { calendar.isDate($0.date, inSameDayAs: date) }
        let isCompleted = tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }.allSatisfy { $0.isCompleted }

        // Determine the new color
        let newColor: String
        if hasTasks && !isCompleted {
            newColor = "red" // Incomplete tasks
        } else if hasTasks && isCompleted {
            newColor = "green" // All tasks completed
        } else {
            newColor = "clear" // Default color (no tasks)
        }

        // Update the color in CalendarModel
        if let calendarDate = calendarDates.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            calendarDate.color = newColor
        } else {
            let newCalendarDate = CalendarModel(date: date, color: newColor)
            modelContext?.insert(newCalendarDate)
        }
        try? modelContext?.save()
    }
    
    func updateDateColor(for date: Date, color: Color) {
        let colorString = String.fromColor(color)
        if let calendarDate = calendarDates.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            calendarDate.color = colorString
        } else {
            let newCalendarDate = CalendarModel(date: date, color: colorString)
            modelContext?.insert(newCalendarDate)
        }
        try? modelContext?.save()
        
        fetchTasks()
    }

    func getAlert(alertType: TaskAlerts) -> Alert {
        switch alertType {
        case .deleteTask:
            if let taskToDelete = self.taskToDelete {
                return Alert(title: Text("Delete Task"), message: Text("Are you sure you want to delete this task?"), primaryButton: .cancel(Text("No")), secondaryButton: .destructive(Text("Yes"), action: {
                    self.deleteTask(taskToDelete)
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["TasksReminder_\(taskToDelete.name)"])
                }))
            }
            return Alert(title: Text("Error"), message: Text("No task selected"))
        case .removeAllTasks:
            return Alert(title: Text("Remove All Tasks"), message: Text("Are you sure you want to remove all tasks for \(formattedDate(self.selectedDate))?"), primaryButton: .cancel(Text("No")), secondaryButton: .destructive(Text("Yes"), action: { self.deleteAllTasks(for: self.selectedDate) }))
        }
    }
    
    func getColorForDate(_ date: Date) -> String? {
        if let calendarDate = calendarDates.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            return calendarDate.color
        }
        return "clear" // Default color
        
    }
    
    func formattedMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: currentMonth)
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func formattedTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short // Show in user’s locale format
        return formatter.string(from: time)
    }
}
extension Color {
    static func fromString(_ string: String) -> Color {
        switch string {
        case "red": return .red
        case "green": return .green
        case "orange": return .orange
        case "clear": return .clear
        default: return .gray // Default color
        }
    }
}

extension String {
    static func fromColor(_ color: Color) -> String {
        if color == .red { return "red" }
        if color == .green { return "green" }
        if color == .orange { return "orange" }
        if color == .blue { return "blue" }
        return "clear" // Default string
    }
}

