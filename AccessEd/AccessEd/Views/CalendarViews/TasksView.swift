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
                ForEach(Array(viewModel.tasksForSelectedDate.enumerated()), id: \.offset) { index, task in
                    HStack {
                        Text("\(task.name)")
                            .font(.subheadline)
                            .foregroundColor(task.isCompleted ? .gray : .primary)
                            .strikethrough(task.isCompleted, color: .gray)
                        
                        Spacer()
                        
                        Button(action: {
                            if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                viewModel.tasks[index].isCompleted.toggle() // Toggle completion
                                viewModel.updateAllTasksCompleted()
                            }
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
                        if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                            viewModel.tasks[index].isCompleted.toggle() // Toggle completion
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
                                    .shadow(radius: 1, x: 0, y: 1)
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
            .frame(width: UIScreen.main.bounds.width)
        }
    }
}


#Preview {
    let viewModel = CalendarViewModel()
    TasksView(viewModel: viewModel)
}
