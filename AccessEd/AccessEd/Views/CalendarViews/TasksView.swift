//
//  TasksView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-19.
//

import SwiftUI
import Foundation

struct TasksView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @State var isCurrentDateSelected: Bool = false
    
    var body: some View {
        VStack {
            if viewModel.tasksForSelectedDate.isEmpty {
//                Text("No tasks for this date.")
//                    .foregroundColor(.gray)
//                    .frame(width: UIScreen.main.bounds.width)
//                    .padding(.top, 50)
                VStack(alignment: .center, spacing: 0) {
                    Image(systemName: "list.bullet.rectangle")
                        .font(Font.system(size: 40))
                        .padding(5)
                        .foregroundStyle(.gray.opacity(0.8))
                        .fontWeight(.light)
                    
                    Text("No tasks for today.")
                        .font(.headline)
                        .bold()
                        .opacity(0.8)
                        .padding(.bottom, 3)
                    
                    Text("Start adding tasks to get started!")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.bottom)
                        .padding(.horizontal, 50)
                        .multilineTextAlignment(.center)
                    
                    
                    Button(action: {
                        viewModel.selectedDate = Date()
                        withAnimation {
                            viewModel.isAddingTask = true
                            
                        }
                    }, label: {
                        Text("Add a Task")
                            .font(.subheadline)
                    })
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding()
                .padding(.vertical)
                .padding(.bottom, 30)
            } else {
                
                // Display the tasks for the selected date
                LazyVStack(alignment: .center, spacing: 5) {
                    TasksSubView(viewModel: viewModel, isCurrentDateSelected: $isCurrentDateSelected)
                }
                .padding(.top, 10)
            }
        }
        
    }
       
}

struct TasksSubView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @Binding var isCurrentDateSelected: Bool
    
    var body: some View {
        VStack(spacing: 25) {
            ForEach(Array(isCurrentDateSelected ? viewModel.tasksForCurrentDate.enumerated() : viewModel.tasksForSelectedDate.enumerated()), id: \.offset) { index, task in
                VStack {
                    HStack {
                        Text("Due: ")
                        Text("\(viewModel.dueTime) - \(viewModel.formattedDate(task.date))")
                        
                        Spacer()
                    }
                    .font(.caption)
                    .foregroundStyle(.gray)
                    
                    Divider()
                        .frame(height: 1)
                    
                    HStack {
                        Text(task.name)
                            .font(.subheadline)
                            .foregroundColor(task.isCompleted ? .gray : .primary)
                            .strikethrough(task.isCompleted, color: .gray)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.handleTaskCompletion(task)
                        }, label: {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .red)
                        })
                    }
                }
                // MARK: TODO: clean this up
                .padding(.vertical, 10)
                .padding(.horizontal, 13)
                .background(Color("Courses-Colors"))
                .cornerRadius(8)
                //            .padding(.trailing, 10)
                .frame(width: UIScreen.main.bounds.width - 60)
                .padding(.leading, 15)
                .shadow(radius: 1, x: 0, y: 0)
                .onTapGesture(count: 2) {
                    viewModel.handleTaskCompletion(task)
                }
                .contextMenu {
                    Button(action: {
                        withAnimation(.easeIn(duration: 0.2)) {
                            viewModel.selectedTaskIndex = index
                            viewModel.isEditingTask = true
                        }
                    }, label: {
                        Label("Edit Task", systemImage: "pencil")
                    })
                    
                    Button(action: {
                        viewModel.taskToDelete = task
                        viewModel.taskAlerts = .deleteTask
                    }, label: {
                        Label("Delete Task", systemImage: "trash")
                    })
                }
            }
        }
        .padding(.bottom, 30)
    }
}



#Preview {
    let viewModel = CalendarViewModel()
    TasksView(viewModel: viewModel)
}
