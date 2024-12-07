//
//  CalendarView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-09.
//

import SwiftUI
import Foundation
import SwiftData

//struct Task: Identifiable {
//    let id = UUID()
//    let date: Date
//    let description: String
//    var completed: Bool = false
//}

struct CalendarView: View {
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date = Date() // Initialize with today’s date
//    @State public var tasks: [Task] = [] // List to store tasks
    @State private var isAddingTask = false // Control task sheet visibility
    @State private var newTaskDescription = "" // Hold new task description
    
    @State private var allTasksCompletedByDate: [Date: Bool] = [:]
    
    //**********
    
    @Query(sort: \Task.id) var fetchedTasks: [Task]
    @State private var tasks: [Task] = []
    
    @Environment(\.modelContext) var tasksContext
    
    //******
    
    @Query(sort: \CalendarModel.date) var calendarDates: [CalendarModel]
        @Environment(\.modelContext) var calendarModelContext
    
    //******
    
    
    // Filter tasks for the selected date
    var tasksForSelectedDate: [Task] {
            tasks.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }
    
    // Filter the uncompleted tasks for the selected date
    var uncompletedTasksForSelectedDate: [Task] {
        tasksForSelectedDate.filter { !$0.completed }
    }
    
    var uncompletedTasksForCurrentDate: [Task] {
        tasks.filter { calendar.isDateInToday($0.date) && !$0.completed }
    }

    
    @State var TaskName: String = ""

    private let calendar = Calendar.current
    
    let fixedWidth: CGFloat = UIScreen.main.bounds.width //* 0.9
    
    
    
    

    var body: some View {
        
        // TODO: need to add the above parameters and variables in a viewModel
//        AccessEdTabView(uncompletedTasksForCurrentDate: uncompletedTasksForCurrentDate.count)
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack {
                        calendarTitleLayerView
                        
                        // Calendar view
                        CalendarEventsView(
                            currentMonth: $currentMonth,
                            tasks: $tasks,
                            selectedDate: $selectedDate,
                            allTasksCompletedByDate: $allTasksCompletedByDate,
//                            uncompletedTasksForSelectedDate: uncompletedTasksForSelectedDate,
//                            tasksForSelectedDate: tasksForSelectedDate,
                            onDateSelected: { date in
                                selectedDate = date // Update selected date when a date is clicked
                            },
                            updateDynamicColor: { date in
                                updateDynamicColor(for: date) // Pass the function
                            }
                        )
                        
                    }
                    .padding(.bottom)
                    .background(Color.gray.opacity(0.05).cornerRadius(40))
                    .onAppear {
                        tasks = fetchedTasks
                        for date in tasks.map({ $0.date }) {
                                updateDynamicColor(for: date)
                            }
                        print(allTasksCompletedByDate)
                    }
                    .onChange(of: fetchedTasks) { newFetchedTasks in
                        tasks = newFetchedTasks
                    }
                    
                    VStack(alignment: .leading) {
                        HStack (alignment: .center){
                            Text("Selected Date:")
                            
                            Text(formattedDate(selectedDate))
                                .font(.title3)
                                .bold()
                        }
                        .padding(.horizontal)
                        
                        
                        HStack(alignment: .center) {

                            Image(systemName: "checklist")
                            Text("Tasks For The Day")
                                .padding(.trailing, 5)
                            
                            // number of uncompleted task for the selected date
                            Text("\(uncompletedTasksForSelectedDate.count)")
                                .foregroundStyle(.purple)
                                .padding(8)
                                .frame(maxWidth: 25, maxHeight: 25)
                                .background(
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .overlay(
                                                Circle()
                                                    .stroke(Color.purple, lineWidth: 0.5)
                                            )
                                )
                                .font(.subheadline)

                            
                            Spacer()
                            
                            addTaskButtonView
                        }
                        .padding(.horizontal)
                        .frame(width: fixedWidth, alignment: .center)
                        .padding(.leading, 10)
                        .padding(.top, 10)

                        
                        if tasksForSelectedDate.isEmpty {
                            Text("No tasks for this date.")
                                .foregroundColor(.gray)
                                .frame(width: fixedWidth)
                                .padding(.top, 30)
                        } else {
                            
                            // Display the tasks for the selected date
                            LazyVStack(alignment: .center, spacing: 10) {
                                ForEach(Array(tasksForSelectedDate.enumerated().reversed()), id: \.offset) { index, task in
                                    HStack {
                                        Text("\(task.name)")
                                            .foregroundColor(task.completed ? .gray : .primary)
                                            .strikethrough(task.completed, color: .gray)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                                tasks[index].completed.toggle() // Toggle completion
                                                updateAllTasksCompleted()
                                            }
                                        }, label: {
                                            Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(task.completed ? .green : .red)
                                        })

                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 13)
                                    .background(Color("Courses-Colors"))
                                    .cornerRadius(8)
                                    .padding(.horizontal, 20)
                                    .frame(width: fixedWidth - 20, alignment: .center)
                                    .padding(.leading)
                                    .shadow(radius: 3, x: 1, y: 2)
                                    .onTapGesture(count: 2) {
                                        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                            tasks[index].completed.toggle() // Toggle completion
                                            updateAllTasksCompleted()
                                        }
                                    }
                                }
                                
                                
                                // Remove all tasks for a day button
                                VStack (alignment: .center) {
                                    Button(action: {
                                        let tasksToDelete = fetchedTasks.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
                                            for task in tasksToDelete {
                                                tasksContext.delete(task)
                                            }
                                            try? tasksContext.save()
                                        
                                        tasks.removeAll { task in
                                            calendar.isDate(task.date, inSameDayAs: selectedDate)
                                        }
                                    }) {
                                        Text("Remove All Tasks")
                                            .font(.callout)
                                            .foregroundStyle(Color("Text-Colors"))
                                            .padding()
                                            .padding(.horizontal, 15)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color("Courses-Colors"))
                                                    .shadow(radius: 3, x: 0, y: 3)
                                                    .frame(width: 160, height: 40)
                                            )
                                    }
                                }
                                .padding()
                                .padding(.top, 20)
                                .frame(width: fixedWidth - 100, alignment: .center)
                            }
                            .padding()
                            .padding(.horizontal)
                            .frame(width: fixedWidth, alignment: .leading)
                        }
                    }
                    .frame(width: fixedWidth)
                    .padding()
                    
                    Spacer()
                }
                .frame(width: fixedWidth, height: .infinity)
                .sheet(isPresented: $isAddingTask, content: {
                    addTaskSheetView
                        .presentationDetents([.medium, .fraction(0.5)])
                        .padding(.top)
                })
                
            }
            .navigationTitle("My Calendar")
        }
    }
    func updateDynamicColor(for date: Date) {
        // Check task state for the date
        let hasTasks = tasks.contains { calendar.isDate($0.date, inSameDayAs: date) }
        let isCompleted = tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }.allSatisfy { $0.completed }

        // Determine the new color
        let newColor: String
        if hasTasks && !isCompleted {
            newColor = "red" // Incomplete tasks
        } else if hasTasks && isCompleted {
            newColor = "green" // All tasks completed
        } else {
            newColor = "blue" // Default color (no tasks)
        }

        // Update the color in CalendarModel
        if let calendarDate = calendarDates.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            calendarDate.color = newColor
        } else {
            let newCalendarDate = CalendarModel(date: date, color: newColor)
            calendarModelContext.insert(newCalendarDate)
        }
        try? calendarModelContext.save()
    }
    
    func saveTasks(_ updatedTasks: [Task]) {
        for task in updatedTasks {
            if fetchedTasks.contains(where: { $0.id == task.id }) {
                // Update existing task
                if let existingTask = fetchedTasks.first(where: { $0.id == task.id }) {
                    existingTask.name = task.name
                }
            } else {
                // Insert new task
                tasksContext.insert(task)
            }
        }
        try? tasksContext.save() // Save changes to SwiftData context
    }
    
    var addTaskButtonView: some View {
        VStack {
            Button(action: {
                isAddingTask = true
            }, label: {
                Text("Add Task")
//                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(10)
//                    .background(
//                        Capsule()
//                            .stroke(Color.gray, lineWidth: 2)
//                    )
            })
        }
        .frame(width: 100, height: 40)
    }
    
    var calendarTitleLayerView: some View {
        HStack {
            Button(action: {
                currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
            }) {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundStyle(.blue)
                    .bold()
            }
            
            Spacer()
            
            // Display the current month and year
            Text("\(formattedMonth())")
                .font(Font.system(size: 20))
            
            Spacer()
            
            Button(action: {
                currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
            }) {
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundStyle(.blue)
                    .bold()
            }
        }
        .padding()
        .padding(.horizontal)
    }
    
    var addTaskSheetView: some View {
        VStack(spacing: 20) {
            Text("Add Task")
                .font(.title3)
                .bold()
                .foregroundStyle(Color("Text-Colors"))
            
            VStack (alignment: .leading) {
                Text("Add Task Name")
                    .padding(.leading)
                TextField("Enter Task Name", text: $TaskName)
                    .padding(10)
                    .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                    .padding([.horizontal, .bottom], 20)
                    .font(.subheadline)
            
                Text("Select Date")
                    .padding(.leading)
                DatePicker("Due Date", selection: $selectedDate, displayedComponents: .date)
                    .padding(10)
                    .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                    .padding(.horizontal, 20)
                    .font(.subheadline)
            }
            .foregroundStyle(Color("Text-Colors"))

            
            HStack(alignment: .center) {
                
                // canel bottom sheet button
                Button(action: { isAddingTask = false }) {
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
                Button {
                    addTask(for: selectedDate, name: TaskName)
                    TaskName = ""
                    isAddingTask = false
                } label: {
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
    }

    
    public func formattedMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: currentMonth)
    }
    
    public func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func addTask(for date: Date, name: String) {
        guard !name.isEmpty else { return }
        let newTask = Task(date: date, name: name, completed: false)

        // Save the new task
        tasksContext.insert(newTask)
        try? tasksContext.save()

        // Update the background color for the date
        updateDynamicColor(for: date)
    }

    
    private func updateAllTasksCompleted() {
        var completionStatus: [Date: Bool] = [:]

            for task in tasks {
                let taskDate = calendar.startOfDay(for: task.date) // Normalize to the start of the day
                let tasksForDate = tasks.filter { calendar.isDate($0.date, inSameDayAs: taskDate) }
                completionStatus[taskDate] = tasksForDate.allSatisfy { $0.completed }
            }

            allTasksCompletedByDate = completionStatus
    }
    
}


#Preview("Light mode") {
    CalendarView()
        .preferredColorScheme(.light)
        .modelContainer(for: Task.self, inMemory: true)
        .modelContainer(for: CalendarModel.self, inMemory: true)
}

#Preview("Dark mode") {
    CalendarView()
        .preferredColorScheme(.dark)
        .modelContainer(for: Task.self, inMemory: true)
        .modelContainer(for: CalendarModel.self, inMemory: true)
}
