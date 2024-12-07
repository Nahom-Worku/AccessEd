//
//  CalendarEventsView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-09.
//

import SwiftUI
import SwiftData

//struct CalendarEventsView: View {
//    
//    //******
//    @Query(sort: \CalendarModel.date) var calendarDates: [CalendarModel]
//    @Environment(\.modelContext) var calendarModelContext
//    
//    //******
//    
//    
//    @Binding var currentMonth: Date
//    @Binding var tasks: [Task]
//    @Binding var selectedDate: Date
//    @Binding var allTasksCompletedByDate: [Date: Bool]
//    var uncompletedTasksForSelectedDate: [Task]
//    var tasksForSelectedDate: [Task]
//    
//    var onDateSelected: (Date) -> Void // Callback to handle date selection
//    var updateDynamicColor: (Date) -> Void
//
//    private let calendar = Calendar.current
//
//    var daysInMonthWithPadding: [Date?] {
//        guard let range = calendar.range(of: .day, in: .month, for: currentMonth),
//              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)),
//              let firstDayOfWeek = calendar.dateComponents([.weekday], from: startOfMonth).weekday else {
//            return []
//        }
//        
//        let padding = Array<Date?>(repeating: nil, count: firstDayOfWeek - 1)
//        let days = range.compactMap { day in
//            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
//        }
//        return padding + days
//    }
//
//    var body: some View {
//        VStack {
//            HStack {
//                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
//                    Text(day)
//                        .font(.caption)
//                        .frame(maxWidth: .infinity)
//                }
//            }
//            .padding(.bottom, 10)
//            
//            
//            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
//                ForEach(daysInMonthWithPadding.indices, id: \.self) { index in
//                    if let date = daysInMonthWithPadding[index] {
//                        
//                        // Conditions for the background color
//                        let hasTasks = tasks.contains { calendar.isDate($0.date, inSameDayAs: date) }
//                        let isCompleted: Bool = !tasksForSelectedDate.isEmpty && uncompletedTasksForSelectedDate.isEmpty // && (allTasksCompletedByDate[date] ?? false)
//                        let isSelected = selectedDate == date
//                        let isToday = calendar.isDateInToday(date)
//
//                        // Stored color from database (if exists)
//                        let storedColor = Color.fromString(getColorForDate(date) ?? "blue").opacity(0.1)
//                        
//                        // Determine final background color based on conditions
//                        let backgroundColor: Color = {
//                            if hasTasks && !isCompleted {
//                                return Color.red.opacity(0.4) // Incomplete tasks
//                            } else if hasTasks && isCompleted {
//                                return Color.green.opacity(0.5) // All tasks completed
//                            } else if isToday {
//                                return Color.yellow.opacity(0.5) // Today
//                            } else if isSelected {
//                                return Color.blue.opacity(0.4) // Selected date
//                            } else {
//                                return storedColor.opacity(0.5) // Fallback to stored color
//                            }
//                        }()
//
//                        
//                        Button(action: {
//                            onDateSelected(date) // Notify parent view
//                            updateDynamicColor(date)
//                            
//                            for i in calendarDates {
//                                print(i.color)
//                            }
//                            
//                        }) {
//                            Text("\(calendar.component(.day, from: date))")
//                                .font(.footnote)
//                                .bold(hasTasks && !isCompleted) // Bold text for dates with incomplete tasks
//                                .frame(width: 35, height: 35, alignment: .center)
//                                .background(backgroundColor) // Use determined background color
//                                .cornerRadius(8)
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                    } else {
//                        Text("") // Empty cell for padding days
//                            .frame(width: 35, height: 35)
//                    }
//                }
//            }
//
//
//            
//        }
//        .padding(.horizontal)
//    }
//    
//    func updateDateColor(for date: Date, color: Color) {
//        let colorString = String.fromColor(color)
//
//        if let calendarDate = calendarDates.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
//            // Update the color
//            calendarDate.color = colorString
//        } else {
//            // Create a new CalendarDate entry
//            let newCalendarDate = CalendarModel(date: date, color: colorString)
//            calendarModelContext.insert(newCalendarDate)
//        }
//
//        try? calendarModelContext.save()
//    }
//
//    func getColorForDate(_ date: Date) -> String? {
//        if let calendarDate = calendarDates.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
//            return calendarDate.color
//        }
//        return "blue" // Default color
//    }
//
//    
//    func updateDynamicColor(for date: Date) {
//        // Check task state for the date
//        let hasTasks = tasks.contains { calendar.isDate($0.date, inSameDayAs: date) }
//        let isCompleted = tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }.allSatisfy { $0.completed }
//
//        // Determine the new color
//        let newColor: String
//        if hasTasks && !isCompleted {
//            newColor = "red" // Incomplete tasks
//        } else if hasTasks && isCompleted {
//            newColor = "green" // All tasks completed
//        } else {
//            newColor = "blue" // Default color (no tasks)
//        }
//
//        // Update the color in CalendarModel
//        if let calendarDate = calendarDates.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
//            calendarDate.color = newColor
//        } else {
//            let newCalendarDate = CalendarModel(date: date, color: newColor)
//            calendarModelContext.insert(newCalendarDate)
//        }
//        try? calendarModelContext.save()
//    }
//
//}

//***********************###########################$%%%%%%%%%%%%%%%%%%%%%%%
// Remove `var uncompletedTasksForSelectedDate: [Task]` and `var tasksForSelectedDate: [Task]`
// from the view's properties. We'll compute per-day completion inline.

struct CalendarEventsView: View {
    @Query(sort: \CalendarModel.date) var calendarDates: [CalendarModel]
    @Environment(\.modelContext) var calendarModelContext

    @Binding var currentMonth: Date
    @Binding var tasks: [Task]
    @Binding var selectedDate: Date
    @Binding var allTasksCompletedByDate: [Date: Bool]

    var onDateSelected: (Date) -> Void
    var updateDynamicColor: (Date) -> Void

    private let calendar = Calendar.current

    var daysInMonthWithPadding: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: currentMonth),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)),
              let firstDayOfWeek = calendar.dateComponents([.weekday], from: startOfMonth).weekday else {
            return []
        }

        let padding = Array<Date?>(repeating: nil, count: firstDayOfWeek - 1)
        let days = range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
        return padding + days
    }

    var body: some View {
        VStack {
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 10)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(daysInMonthWithPadding.indices, id: \.self) { index in
                    if let date = daysInMonthWithPadding[index] {
                        // Filter tasks for this specific cell's date
                        let cellTasks = tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
                        let cellUncompletedTasks = cellTasks.filter { !$0.completed }
                        
                        let hasTasks = !cellTasks.isEmpty
                        let isCompleted = !cellTasks.isEmpty && cellUncompletedTasks.isEmpty

                        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                        let isToday = calendar.isDateInToday(date)

                        // Get stored color if any
                        let storedColorName = getColorForDate(date) ?? "blue"
                        let storedColor = Color.fromString(storedColorName).opacity(0.2)

                        // Determine final background color based on conditions
                        let backgroundColor: Color = {
                            
                            // TODO: update this if statement so that the bg color is updated as expected
                            if isToday {
                                return Color.yellow.opacity(0.5) // Today
                            } else if isSelected {
                                return Color.blue.opacity(0.4) // Selected date
                            } else if hasTasks && !isCompleted {
                                return Color.red.opacity(0.3) // Incomplete tasks
                            } else if hasTasks && isCompleted {
                                return Color.green.opacity(0.3) // All tasks completed
                            } else {
                                return storedColor.opacity(0.5) // Stored or default color
                            }
                        }()

                        Button(action: {
                            onDateSelected(date)
                            updateDynamicColor(date)
                        }) {
                            let dayNumber = calendar.component(.day, from: date)
                            let textValue = isToday ? "•\(dayNumber)•" : "\(dayNumber)"
                            
                            Text(textValue)
                                .font(.footnote)
                                .bold(hasTasks && !isCompleted)
                                .frame(width: 35, height: 35, alignment: .center)
                                .background(backgroundColor)
                                .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        Text("") // Empty cell for padding days
                            .frame(width: 35, height: 35)
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    func updateDateColor(for date: Date, color: Color) {
        let colorString = String.fromColor(color)
        if let calendarDate = calendarDates.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            calendarDate.color = colorString
        } else {
            let newCalendarDate = CalendarModel(date: date, color: colorString)
            calendarModelContext.insert(newCalendarDate)
        }
        try? calendarModelContext.save()
    }

    func getColorForDate(_ date: Date) -> String? {
        if let calendarDate = calendarDates.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            return calendarDate.color
        }
        return "blue" // Default color
    }

    func updateDynamicColor(for date: Date) {
        let cellTasks = tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
        let allCompleted = cellTasks.allSatisfy { $0.completed }

        let newColor: String
        if !cellTasks.isEmpty && !allCompleted {
            newColor = "red"
        } else if !cellTasks.isEmpty && allCompleted {
            newColor = "green"
        } else {
            newColor = "blue"
        }

        if let calendarDate = calendarDates.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            calendarDate.color = newColor
        } else {
            let newCalendarDate = CalendarModel(date: date, color: newColor)
            calendarModelContext.insert(newCalendarDate)
        }
        try? calendarModelContext.save()
    }
}


extension Color {
    static func fromString(_ string: String) -> Color {
        switch string {
        case "red": return .red
        case "green": return .green
        case "orange": return .orange
        case "blue": return .blue
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
        return "gray" // Default string
    }
}



//#Preview {
//    CalendarChildView(currentMonth: <#Binding<Date>#>, tasks: <#Binding<[Task]>#>, onDateSelected: <#(Date) -> Void#>)
//}
