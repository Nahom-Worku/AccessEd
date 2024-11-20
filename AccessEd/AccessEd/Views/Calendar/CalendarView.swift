//
//  CalendarView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-09.
//

import SwiftUI
import Foundation

struct Task: Identifiable {
    let id = UUID()
    let date: Date
    let description: String
    var completed: Bool = false
}

struct CalendarView: View {
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date = Date() // Initialize with today’s date
    @State public var tasks: [Task] = [] // List to store tasks
    @State private var isAddingTask = false // Control task sheet visibility
    @State private var newTaskDescription = "" // Hold new task description
    
//    @State private var allTasksCompleted: Bool = false
    @State private var allTasksCompletedByDate: [Date: Bool] = [:]

    
    @State var courseName: String = ""
    @State var grade: String = ""

    private let calendar = Calendar.current
    
    
    @EnvironmentObject var listViewModel: ListViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    calendarTitleLayerView
                    
                    // Calendar view
                    CalendarEventsView(
                        currentMonth: $currentMonth,
                        tasks: $tasks,
                        allTasksCompletedByDate: $allTasksCompletedByDate,
                        onDateSelected: { date in
                            selectedDate = date // Update selected date when a date is clicked
                        }
                    )
                    
                }
                .padding(.bottom)
                .background(Color.gray.opacity(0.05).cornerRadius(40))
                .padding(.horizontal, 5)
                
                VStack(alignment: .leading) {
                    HStack (alignment: .center){
                        Text("\(formattedDate(selectedDate))")
                            .font(.title3)
                            .bold()
                            .padding(.leading)
                        
                        Spacer()
                        
                        addTaskButtonView
                    }
                    
                    HStack(alignment: .center) {
                        Image(systemName: "checklist")
                        Text("Your Tasks For The Day")
                        
                    }
                    .frame(width: 370, height: 50)
                    
                    
                    // Filter tasks for the selected date
                    let tasksForSelectedDate = tasks.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
                    
                    if tasksForSelectedDate.isEmpty {
                        Text("No tasks for this date.")
                            .foregroundColor(.gray)
                            .frame(width: 380, height: 80, alignment: .center)
                    } else {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 10) {
                                ForEach(Array(tasksForSelectedDate.enumerated()), id: \.offset) { index, task in
                                    HStack {
                                        if task.completed {
                                            Text(" \(index + 1).)  \(task.description)")
                                                .strikethrough(task.completed, color: .gray) // Strikethrough if completed
                                                .foregroundColor(.gray)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        } else {
                                            Text(" \(index + 1).)  \(task.description)")
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "circle")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 10)
                                    .frame(width: .infinity, height: 50)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 3, x: 1, y: 2)
                                    .onTapGesture(count: 2) {
                                        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                            tasks[index].completed.toggle() // Toggle completion
                                            updateAllTasksCompleted()
                                            print("\n -> \(allTasksCompletedByDate)")
                                            for (index, task) in tasks.enumerated() {
                                                print("Task \(index + 1): \(task.description) - Completed: \(task.completed) \n")
                                            }
                                        }
                                    }
                                    .onAppear {
                                        print(" -> \(allTasksCompletedByDate)")
                                        for (index, task) in tasks.enumerated() {
                                            print("Task \(index + 1): \(task.description) - Completed: \(task.completed) \n")
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                        .frame(maxHeight: .infinity)
                    }
                }
                .padding()
                
                Spacer()
            }
        }
        .padding(.top, 10)
        .navigationTitle("My Calendar")
        .background(Color.gray.opacity(0.1))
        .sheet(isPresented: $isAddingTask, content: {
            addTaskSheetView
                .presentationDetents([.medium, .fraction(0.5)])
        })
    }
    
    var addTaskButtonView: some View {
        VStack {
            Button(action: {
                isAddingTask = true
            }, label: {
                Text("Add Task")
                    .font(.callout)
                    .bold()
                    .foregroundColor(.gray)
                    .padding(10)
                    .background(
                        Capsule()
                            .stroke(Color.gray, lineWidth: 2)
                    )
            })
        }
        .frame(width: 100, height: 40)
    }
    
    var calendarTitleLayerView: some View {
        HStack {
            Button(action: {
                currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
            }) {
                Text("Previous")
            }
            
            Spacer()
            
            // Display the current month and year
            Text("\(formattedMonth())")
                .font(Font.system(size: 20))
            
            Spacer()
            
            Button(action: {
                currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
            }) {
                Text("Next")
            }
        }
        .padding()
    }
    
    var addTaskSheetView: some View {
            VStack (alignment: .center) {
                Text("Add Task for \(formattedDate(selectedDate))")
                    .font(Font.system(size: 20))
                    .padding()
                    .padding(.vertical, 10)
                
                TextField("Enter Course Name", text: $courseName)
                    .padding(10)
                    .background(Color.white.cornerRadius(10.0))
                    .padding(.horizontal, 20)
                    .foregroundStyle(Color.black)
                    .font(.subheadline)
                
                
                // Buttons
                HStack {
                    
                    // Cancel button
                    Button {
                        isAddingTask = false
                    } label: {
                        Text("Canel")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.red.opacity(0.6))
                                    .frame(width: 120, height: 40)
                            )
                    }

                    Spacer()
                    
                    // Add course button
                    Button {
//                        if !newTaskDescription.isEmpty {
//                            addTask(for: selectedDate, description: newTaskDescription)
//                            newTaskDescription = "" // Clear the text field
//                            isAddingTask = false // Dismiss the sheet
//                        }
                        
                        addTask(for: selectedDate, description: courseName)
                        courseName = ""
                        isAddingTask = false
                    } label: {
                        Text("Add")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue.opacity(0.6))
                                    .frame(width: 120, height: 40)
                            )
                    }
                }
                .padding()
                .frame(maxWidth: 240, maxHeight: 100)
                .foregroundStyle(Color.black)
            }
            .frame(maxWidth: 300, maxHeight: 250)
            .padding()
            .padding(.vertical, 10)
            .background(
                Color.gray.opacity(0.1)
                    .cornerRadius(15)
                    .shadow(
                        color: Color.black.opacity(0.3),
                        radius: 5,
                        x: 0.0,
                        y: 10 )
            )
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
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
    
    private func addTask(for date: Date, description: String) {
        guard !description.isEmpty else { return }
        let newTask = Task(date: date, description: description, completed: false)
        tasks.append(newTask)
        newTaskDescription = "" // Clear the input field
        updateAllTasksCompleted() // Recalculate all tasks completion
    }
    
    private func updateAllTasksCompleted() {
        var completionStatus: [Date: Bool] = [:]

        // Group tasks by their date and check if all are completed
        for task in tasks {
            let taskDate = calendar.startOfDay(for: task.date)
            let tasksForDate = tasks.filter { calendar.isDate($0.date, inSameDayAs: taskDate) }
            completionStatus[taskDate] = tasksForDate.allSatisfy { $0.completed }
        }

        allTasksCompletedByDate = completionStatus
    }
}


#Preview {
    CalendarView()
        .environmentObject(ListViewModel())
}
