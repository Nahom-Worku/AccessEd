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
                VStack(alignment: .center, spacing: 0) {
                    Image(systemName: "list.bullet.rectangle")
                        .font(Font.system(size: 40))
                        .padding(5)
                        .foregroundStyle(.gray.opacity(0.8))
                        .fontWeight(.light)
                    
                    Text("No tasks for \(viewModel.formattedDate(viewModel.selectedDate)).")
                        .font(.subheadline)
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
                        withAnimation { viewModel.isAddingTask = true }
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
        VStack(spacing: 15) {
            ForEach(Array(isCurrentDateSelected ? viewModel.tasksForCurrentDate.enumerated() : viewModel.tasksForSelectedDate.enumerated()), id: \.offset) { index, task in
                VStack(spacing: 3) {
                    HStack {
                        Text("Due: ")
                            .fontWeight(.medium)
                        Text("\(viewModel.formattedDate(task.date)) • \(viewModel.formattedTime(task.time))")
                        Spacer()
                    }
                    .font(.caption)
                    .foregroundStyle(.gray)
                    
                    Divider()
                        .frame(height: 5)
                        .foregroundStyle(.gray)
                    
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
                    .padding(.vertical, 3)
                }
                // MARK: TODO: clean this up
                .padding(.vertical, 10)
                .padding(.horizontal, 13)
                .background(Color("Task-Colors"))
                .cornerRadius(8)
                .frame(width: UIScreen.main.bounds.width - 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 0.25)
                )
                .padding(.leading, 15)
                .onTapGesture(count: 2) { viewModel.handleTaskCompletion(task) }
                .contextMenu {
                    Button(action: {
                        withAnimation(.easeIn(duration: 0.2)) {
                            viewModel.selectedTaskIndex = index
                            viewModel.isEditingTask = true
                        }
                    }) {
                        Label("Edit Task", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: {
                        viewModel.taskToDelete = task
                        viewModel.taskAlerts = .deleteTask
                    }) {
                        Label("Delete Task", systemImage: "trash")
                    }
                }
            }
        }
        .padding(.bottom)
    }
}



#Preview {
    let viewModel = CalendarViewModel()
    TasksView(viewModel: viewModel)
}
