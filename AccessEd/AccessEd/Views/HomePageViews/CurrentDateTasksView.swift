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
        if viewModel.tasksForCurrentDate.isEmpty {
            Text("No tasks for today.")
                .foregroundColor(.gray)
                .padding(.trailing, 40)
                .padding(.top, 50)
                .frame(width: UIScreen.main.bounds.width, alignment: .center)
        } else {
            LazyVStack(alignment: .center, spacing: 10) {
                ForEach(Array(viewModel.tasksForCurrentDate.enumerated()), id: \.offset) { index, task in
                    HStack {
                        Text("\(task.name)")
                            .font(.subheadline)
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
                    .padding(.trailing, 20)
                    .frame(width: UIScreen.main.bounds.width - 60)
                    .shadow(radius: 1, x: 1, y: 1)
                    .onTapGesture(count: 2) {
                        if let index = viewModel.tasks.firstIndex(where: { $0.id == task.id }) {
                            viewModel.tasks[index].completed.toggle()
                            viewModel.updateAllTasksCompleted()
                        }
                    }
                }
            }
            .padding()
            .padding(.horizontal)
            .frame(width: UIScreen.main.bounds.width)
        }
    }
}
