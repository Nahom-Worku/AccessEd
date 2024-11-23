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
    
    let fixedWidth: CGFloat = UIScreen.main.bounds.width //* 0.9

    var body: some View {
        ScrollView {
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
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    HStack (alignment: .center){
                        Text("Selected Date:")
                            
                        
                        Text(formattedDate(selectedDate))
                            .font(.title3)
                            .bold()
                    }
                    .padding(.horizontal)
                    
                    
                    HStack(alignment: .center) {
//                        Section {
                            Image(systemName: "checklist")
                            Text("Your Tasks For The Day")
//                        }
//                        .padding(.leading, 10)
                        
                        Spacer()
                        
                        addTaskButtonView
                    }
                    .padding(.horizontal)
                    .frame(width: fixedWidth - 20, alignment: .center)
                    .padding(.leading, 10)
                    .padding(.top, 10)
                    
                    // Filter tasks for the selected date
                    let tasksForSelectedDate = tasks.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
                    
                    if tasksForSelectedDate.isEmpty {
                        Text("No tasks for this date.")
                            .foregroundColor(.gray)
                            .frame(width: fixedWidth)
                            .padding(.top, 30)
                    } else {
                        LazyVStack(alignment: .center, spacing: 10) {
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
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 10)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .padding(.horizontal, 20)
                                    .frame(width: fixedWidth, alignment: .center)
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
                                
                                
                                // Remove all tasks for a day button
                                VStack (alignment: .center) {
                                    Button(action: {
                                        tasks.removeAll { task in
                                            calendar.isDate(task.date, inSameDayAs: selectedDate)
                                        }
                                    }) {
                                        Text("Remove All Tasks")
                                            .font(.callout)
                                            .bold()
                                            .foregroundColor(.white)
                                            .padding()
                                            .padding(.horizontal, 15)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.gray.opacity(0.7))
                                                    .frame(width: 160, height: 40)
                                            )
                                    }
                                }
                                .padding()
                                .padding(.top, 40)
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
        .frame(width: fixedWidth)
        .padding(.top, 10)
        .padding(.horizontal)
        .navigationTitle("My Calendar")
        .background(Color.gray.opacity(0.1).ignoresSafeArea())
        .sheet(isPresented: $isAddingTask, content: {
            addTaskSheetView
                .presentationDetents([.medium, .fraction(0.5)])
                .padding(.top)
        })
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
            
            VStack (alignment: .leading) {
                Text("Add Task Name")
                    .padding(.leading)
                TextField("Enter Task Name", text: $courseName)
                    .padding(10)
                    .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                    .padding([.horizontal, .bottom], 20)
                    .foregroundStyle(Color.black)
                    .font(.subheadline)
            
                Text("Select Date")
                    .padding(.leading)
                DatePicker("Due Date", selection: $selectedDate, displayedComponents: .date)
                    .padding(10)
                    .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                    .padding(.horizontal, 20)
                    .foregroundStyle(Color.black)
                    .font(.subheadline)
            }

            
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
            Color(.white)
                .cornerRadius(15)
                .shadow(radius: 3, x: 0, y: 1)
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
