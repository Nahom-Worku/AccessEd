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
                Text("No tasks for this date.")
                    .foregroundColor(.gray)
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.top, 50)
            } else {
                
                // Display the tasks for the selected date
                LazyVStack(alignment: .center, spacing: 5) {
                    TasksSubView(viewModel: viewModel, isCurrentDateSelected: $isCurrentDateSelected)
                    
                    // Complete / Remove all tasks for a day button
                    if viewModel.tasksForSelectedDate.count > 1 {
                        
                        VStack(spacing: 0) {
                            Button(action: {
                                viewModel.completeAllTasks(for: viewModel.selectedDate)
                            }) {
                                Text("Complete All")
                                    .font(.callout)//.system(size: 16))
                                    .foregroundStyle(.green) //Color("Text-Colors"))
                                    .padding()
                                    .padding(.horizontal, 15)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color("Courses-Colors"))
                                            .shadow(radius: 1, x: 0, y: 1)
                                            .frame(width:  UIScreen.main.bounds.width - 70, height: 40, alignment: .center)
                                    )
                            }
                            
                            
                            Button(action: {
                                withAnimation(.easeOut) {
                                    viewModel.taskAlerts = .removeAllTasks
                                }
                            }) {
                                Text("Remove All")
                                    .font(.callout)
                                    .foregroundStyle(.red)//Color("Text-Colors"))
                                    .padding()
                                    .padding(.horizontal, 15)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color("Courses-Colors"))
                                            .shadow(radius: 1, x: 0, y: 1)
                                            .frame(width:  UIScreen.main.bounds.width - 70, height: 40, alignment: .center)
                                    )
                            }
                        }
                        .padding(.top, 30)
                        .padding(.vertical)
                        .padding(.horizontal)
                        .frame(width: UIScreen.main.bounds.width)
                    }
                }
                .padding(.top, 10)
                .padding(.leading, 30)
            }
        }
        
    }
       
}

struct TasksSubView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @Binding var isCurrentDateSelected: Bool
//    @State private var showDeleteConfirmation: Bool = false
    
    var body: some View {
        ForEach(Array(isCurrentDateSelected ? viewModel.tasksForCurrentDate.enumerated() : viewModel.tasksForSelectedDate.enumerated()), id: \.offset) { index, task in
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
            // MARK: TODO: clean this up
            .padding(.vertical, 10)
            .padding(.horizontal, 13)
            .background(Color("Courses-Colors"))
            .cornerRadius(8)
            .padding(.trailing, 20)
            .frame(width: UIScreen.main.bounds.width - 60)
            .padding(.leading, 20)
            .shadow(radius: 1, x: 1, y: 1)
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
//                        showDeleteConfirmation = true
                }, label: {
                    Label("Delete Task", systemImage: "trash")
                })
            }
        }
//        .confirmationDialog("Delete Profile", isPresented: $showDeleteConfirmation) {
//            Button("Delete", role: .destructive) { }
//            Button("Cancel", role: .cancel) { }
//        } message: {
//            Text("Are you sure you want to delete your profile? This action cannot be undone.")
//        }
    }
}



#Preview {
    let viewModel = CalendarViewModel()
    TasksView(viewModel: viewModel)
}
