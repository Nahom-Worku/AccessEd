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
    
    var body: some View {
        
        if viewModel.tasksForSelectedDate.isEmpty {
            Text("No tasks for this date.")
                .foregroundColor(.gray)
                .frame(width: UIScreen.main.bounds.width)
                .padding(.top, 50)
        } else {
            
            // Display the tasks for the selected date
            LazyVStack(alignment: .center, spacing: 10) {
                TasksSubView(viewModel: viewModel)
                
                // Remove all tasks for a day button
                VStack(spacing: 0) {
                    Button(action: {
                        viewModel.completeAllTasks(for: viewModel.selectedDate)
                    }) {
                        Text("Complete All")
                            .font(.system(size: 16))
                            .foregroundStyle(.green) //Color("Text-Colors"))
                            .padding()
                            .padding(.horizontal, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("Courses-Colors"))
                                    .shadow(radius: 1, x: 0, y: 1)
                                    .frame(width: 150, height: 40)
                            )
                    }
                    
                    
                    Button(action: {
                        withAnimation(.easeOut) {
                            viewModel.deleteAllTasks(for: viewModel.selectedDate)
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
                                    .frame(width: 150, height: 40)
                            )
                    }
                }
                .padding()
                .padding(.horizontal)
                .padding(.top, 30)
                .frame(width: UIScreen.main.bounds.width, alignment: .center)
            }
            .padding()
            .padding(.horizontal)
            .frame(width: UIScreen.main.bounds.width)
        }
    }
}

struct TasksSubView: View {
    @ObservedObject var viewModel: CalendarViewModel

    var body: some View {
        ForEach(Array(viewModel.tasksForSelectedDate.enumerated()), id: \.offset) { index, task in
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
                    viewModel.deleteTask(task)
                }, label: {
                    Label("Delete Task", systemImage: "trash")
                })
            }
        }
//        .sheet(isPresented: $viewModel.isEditingTask) {
//            if let taskIndex = viewModel.selectedTaskIndex {
//                if taskIndex >= 0 && taskIndex < viewModel.tasksForSelectedDate.count {
//                    EditTaskSheetView(viewModel: viewModel, taskIndex: taskIndex)
//                        .presentationDetents([.medium, .fraction(0.5)])
//                        .padding(.top)
//                }
//            } else {
//                Text("No Task Selected")
//            }
//        }

    }
}



#Preview {
    let viewModel = CalendarViewModel()
    TasksView(viewModel: viewModel)
}
