//
//  CalendarLayerView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-05.
//

import SwiftUI

struct CalendarLayerView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("ToDo List")
                .font(.title)
                .bold()
                .padding(.leading, 15) // 20
            
            HStack {
                Text("Uncompleted tasks for today")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("\(viewModel.uncompletedTasksForCurrentDate.count)")
                    .foregroundStyle(.purple)
                    .padding(10)
                    .frame(maxWidth: 35, maxHeight: 30)
                    .background(
                        Circle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 25)
                            .overlay(
                                Circle()
                                    .stroke(Color.purple, lineWidth: 0.5)
                            )
                    )
                    .font(.caption)
                
                TaskActionsView(viewModel: viewModel)
            }
            .padding(.leading, 20) // .horizontal, 25
//            .padding(.top, 3)
//            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            
            CurrentDateTasksView(viewModel: viewModel)
                .padding(.top, 10)
            
        }
        .padding()
//        .frame(width: UIScreen.main.bounds.width)
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.fetchTasks()
        }
        .confirmationDialog (
            "Task Actions",
            isPresented: $viewModel.showTaskActions,
            titleVisibility: .visible
        ) {
            Button("Complete All Tasks", role: .none) {
                viewModel.completeAllTasks(for: viewModel.selectedDate)
            }
            Button("Remove All Tasks", role: .destructive) {
                viewModel.deleteAllTasks(for: viewModel.selectedDate)
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    let viewModel: CalendarViewModel = CalendarViewModel()
    CalendarLayerView()
        .environmentObject(viewModel)
}
