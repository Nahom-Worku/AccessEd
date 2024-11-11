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
        VStack {
            Text("Selected Month: \(formattedMonth(currentMonth))")
            
            // Calendar view
            CalendarChildView(
                currentMonth: $currentMonth,
                tasks: $tasks,
                onDateSelected: { date in
                    selectedDate = date // Update selected date when a date is clicked
                }
            )

//            Spacer()
            
            // Tasks for the selected or default date (today)
            VStack (alignment: .leading) {
                Text("\(formattedDate(selectedDate))")
                    .font(.title2)
                    .padding()
                    .padding(.vertical)
                    
                VStack (alignment: .leading){
                    //                    VStack {
                    //                        Text("\(formattedDate(selectedDate))")
                    //                            .font(.title2)
                    //                    }
                    //                    .padding()
                    
                    let tasksForSelectedDate = tasks.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
                    
                    if tasksForSelectedDate.isEmpty {
                        Text("No tasks for this date.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(Array(tasksForSelectedDate.reversed().enumerated()), id: \.1.id) { index, task in
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
                    
                    // Button to add a new task
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
                    .padding()
                    
                }C
                .padding()
                .padding(.horizontal)
                .frame(width: 400, height: .infinity, alignment: .leading)
//                .background(Color.yellow.opacity(0.2))
//                .navigationTitle(Text("\(formattedDate(selectedDate))"))
            }
            
            Spacer()
        }
        .sheet(isPresented: $isAddingTask) {
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
