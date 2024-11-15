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
    @State private var tasks: [Task] = [] // List to store tasks
    @State private var isAddingTask = false // Control task sheet visibility
    @State private var newTaskDescription = "" // Hold new task description

    private let calendar = Calendar.current

    var body: some View {
        ScrollView {
            VStack {
                Text("Calendar + To-Do List")
                    .padding()
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                
                VStack {
                    calendarTitleLayerView
                    
                    // Calendar view
                    CalendarEventsView(
                        currentMonth: $currentMonth,
                        tasks: $tasks,
                        onDateSelected: { date in
                            selectedDate = date // Update selected date when a date is clicked
                        }
                    )
                }
                .padding(.bottom)
                .background(Color.gray.opacity(0.05).cornerRadius(40))
                .padding(.horizontal ,5)
                
                
                VStack (alignment: .leading) {
                    Text("\(formattedDate(selectedDate))")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    
                    let tasksForSelectedDate = tasks.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
                    
                    if tasksForSelectedDate.isEmpty {
                        VStack {
                            Text("No tasks for this date.")
                                .foregroundColor(.gray)
                        }
                        .frame(width: 350, height: 80)
                        //                        .background(.green.opacity(0.3))
                    } else {
                        List {
                            Section ( header:
                                        HStack {
                                            Text("My Tasks")
                                            Image(systemName: "checklist")
                                        }
                                        .foregroundColor(.black)
                                        .font(.headline)
                            ){
                                ForEach(Array(tasksForSelectedDate.enumerated()), id: \.1.id) { index, task in
                                    Text("\(index + 1).) \(task.description)")
                                        .font(.body)
                                        .strikethrough(task.completed, color: .gray) // Apply strikethrough if completed
                                        .foregroundColor(task.completed ? .gray : .primary)
                                        .onTapGesture(count: 2) {
                                            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                                                tasks[index].completed.toggle() // Toggle completion on double click
                                            }
                                        }
                                }
                            }
                        }
                        .frame(width: .infinity, height: 180)
                        .padding()
//                                .cornerRadius(50)
//                                .shadow(radius: 10)
                        .padding(.bottom, 10)
                    }
                    
                    
                    // Button to add a new task
                    VStack {
                        Button(action: {
                            isAddingTask = true
                        }, label: {
                            Text("Add Task".uppercased())
                                .font(.caption)
                                .bold()
                                .foregroundColor(.gray)
                                .padding()
                                .padding(.horizontal, 15)
                                .background(
                                    Capsule()
                                        .stroke(Color.gray, lineWidth: 2)
                                )
                        })
                    }
                    .padding()
                    .frame(width: 350, height: 50)
                    //                    .background(Color.yellow)
                }
                .padding()
                .frame(width: 400, height: .infinity, alignment: .leading)
                
                Spacer()
            }
            .sheet(isPresented: $isAddingTask, content: { addTaskSheetView })
        }
        .background(Color.gray.opacity(0.1))
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
        VStack {
            Text("Add Task for \(formattedDate(selectedDate))")
                .font(.headline)
                .padding()
            
            TextField("Task description", text: $newTaskDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Add") {
                if !newTaskDescription.isEmpty {
                    addTask(for: selectedDate, description: newTaskDescription)
                    newTaskDescription = "" // Clear the text field
                    isAddingTask = false // Dismiss the sheet
                }
            }
            .padding()
            
            Button("Cancel") {
                isAddingTask = false // Dismiss the sheet without adding
            }
            .foregroundColor(.red)
            .padding()
        }
        .padding()
    }
    
    private func formattedMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: currentMonth)
    }
    
    private func formattedMonth(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }

    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    // Function to add a task
    private func addTask(for date: Date, description: String) {
        let task = Task(date: date, description: description)
        tasks.append(task)
    }
}

#Preview {
    CalendarView()
}
