//
//  CurrentDateTasksView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-19.
//

import SwiftUI

struct CurrentDateTasksView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack {
            if viewModel.tasksForCurrentDate.isEmpty {
                Text("No tasks for today.")
                    .foregroundColor(.gray)
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.top, 30)
            } else {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(viewModel.tasksForCurrentDate.enumerated()), id: \.offset) { index, task in  // tasksForSelectedDate
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
                        .frame(width: UIScreen.main.bounds.width - 40)
                        .shadow(radius: 1, x: 1, y: 1)
                        .onTapGesture(count: 2) {
                            if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                                viewModel.tasks[index].completed.toggle() // Toggle completion
                                viewModel.updateAllTasksCompleted()
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
    }
}
