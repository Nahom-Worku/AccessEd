//
//  CalendarView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-09.
//

import SwiftUI
import Foundation
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var viewModel = CalendarViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack {
                        calendarTitleLayerView
                        
                        // Calendar view
                        CalendarEventsView ( viewModel: viewModel )
                        
                    }
                    .padding(.bottom)
                    .background(Color.gray.opacity(0.05).cornerRadius(40))
                    .onAppear {
                        viewModel.tasks = viewModel.fetchedTasks
                        for date in viewModel.tasks.map({ $0.date }) {
                            viewModel.updateDynamicColor(for: date)
                        }
                    }
                    
                    // Tasks View
                    VStack(alignment: .leading) {
                        HStack (alignment: .center){
                            Text("Selected Date:")
                            
                            Text(viewModel.formattedDate(viewModel.selectedDate))
                                .font(.title3)
                                .bold()
                        }
                        .padding(.horizontal)
                        
                        
                        HStack(alignment: .center) {

                            Image(systemName: "checklist")
                            Text("Tasks For The Day")
                                .padding(.trailing, 5)
                            
                            // number of uncompleted task for the selected date
                            Text("\(viewModel.uncompletedTasksForSelectedDate.count)")
                                .foregroundStyle(.purple)
                                .padding(8)
                                .frame(maxWidth: 35, maxHeight: 30)
                                .background(
                                    Circle()
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(width: 30)
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
                        .frame(width: UIScreen.main.bounds.width, alignment: .center)
                        .padding(.leading, 10)
                        .padding(.top, 10)

                        
                        if viewModel.tasksForSelectedDate.isEmpty {
                            Text("No tasks for this date.")
                                .foregroundColor(.gray)
                                .frame(width: UIScreen.main.bounds.width)
                                .padding(.top, 30)
                        } else {
                            
                            // Display the tasks for the selected date
                            LazyVStack(alignment: .center, spacing: 10) {
                                ForEach(Array(viewModel.tasksForSelectedDate.enumerated()), id: \.offset) { index, task in
                                    HStack {
                                        Text("\(task.name)")
                                            .foregroundColor(task.completed ? .gray : .primary)
                                            .strikethrough(task.completed, color: .gray)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                                viewModel.tasks[index].completed.toggle() // Toggle completion
                                                viewModel.updateAllTasksCompleted()
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
                                    .frame(width: UIScreen.main.bounds.width - 20, alignment: .center)
                                    .padding(.leading)
                                    .shadow(radius: 3, x: 1, y: 2)
                                    .onTapGesture(count: 2) {
                                        if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                            viewModel.tasks[index].completed.toggle() // Toggle completion
                                            viewModel.updateAllTasksCompleted()
                                        }
                                    }
                                }
                                
                                
                                // Remove all tasks for a day button
                                VStack (alignment: .center) {
                                    Button(action: {
                                        viewModel.deleteAllTasks(for: viewModel.selectedDate)
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
                                .frame(width: UIScreen.main.bounds.width - 100, alignment: .center)
                            }
                            .padding()
                            .padding(.horizontal)
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding()
                    
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width)
                .sheet(isPresented: $viewModel.isAddingTask, content: {
                    addTaskSheetView
                        .presentationDetents([.medium, .fraction(0.5)])
                        .padding(.top)
                })
                
            }.onAppear {
                viewModel.modelContext = modelContext
//                viewModel.calendar = calendar
                viewModel.fetchTasks()
                
                viewModel.onDateSelected = { date in
                    viewModel.selectedDate = date
                }
                
                viewModel.updateDynamicColor = { date in
                    viewModel.updateDynamicColor(for: date)
                }
            }
            .navigationTitle("My Calendar")
        }
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.fetchTasks()
            
            viewModel.onDateSelected = { date in
                viewModel.selectedDate = date
            }
            
            viewModel.updateDynamicColor = { date in
                viewModel.updateDynamicColor(for: date)
            }
        }
    }
    
    
    var addTaskButtonView: some View {
        VStack {
            Button(action: {
                viewModel.isAddingTask = true
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
                viewModel.currentMonth = viewModel.calendar.date(byAdding: .month, value: -1, to: viewModel.currentMonth) ?? viewModel.currentMonth
            }) {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundStyle(.blue)
                    .bold()
            }
            
            Spacer()
            
            // Display the current month and year
            Text("\(viewModel.formattedMonth())")
                .font(Font.system(size: 20))
            
            Spacer()
            
            Button(action: {
                viewModel.currentMonth = viewModel.calendar.date(byAdding: .month, value: 1, to: viewModel.currentMonth) ?? viewModel.currentMonth
            }) {
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundStyle(.blue)
                    .bold()
            }
        }
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.fetchTasks()
            
            viewModel.onDateSelected = { date in
                viewModel.selectedDate = date
            }
            
            viewModel.updateDynamicColor = { date in
                viewModel.updateDynamicColor(for: date)
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
                TextField("Enter Task Name", text: $viewModel.TaskTitle)
                    .padding(10)
                    .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                    .padding([.horizontal, .bottom], 20)
                    .font(.subheadline)
            
                Text("Select Date")
                    .padding(.leading)
                DatePicker("Due Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .padding(10)
                    .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                    .padding(.horizontal, 20)
                    .font(.subheadline)
            }
            .foregroundStyle(Color("Text-Colors"))

            
            HStack(alignment: .center) {
                
                // canel bottom sheet button
                Button(action: { viewModel.isAddingTask = false }) {
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
                    viewModel.addTask(for: viewModel.selectedDate, name: viewModel.TaskTitle)
                    viewModel.TaskTitle = ""
                    viewModel.isAddingTask = false
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
}


#Preview("Light mode") {
    CalendarView()
        .preferredColorScheme(.light)
        .modelContainer(for: [Task.self, CalendarModel.self], inMemory: true)
}

#Preview("Dark mode") {
    CalendarView()
        .preferredColorScheme(.dark)
        .modelContainer(for: [Task.self, CalendarModel.self], inMemory: true)
}
