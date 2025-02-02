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
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("ToDo List")
                        .font(.title)
                        .bold()
                    
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
                    }
                }
                
                Spacer()
                
                TaskActionsView(viewModel: viewModel)
            }
            .padding(.trailing, 5)
            .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
            .padding(.leading, 20)
            
            LazyVStack {
                CurrentDateTasksView(viewModel: viewModel)
            }
            .padding(.horizontal, 20)
//            .padding(.leading, 5)
            .frame(width: UIScreen.main.bounds.width, alignment: .center)
            .padding(.top, 10)
            
        }
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.fetchTasks()
        }
    }
}

#Preview {
    let viewModel: CalendarViewModel = CalendarViewModel()
    CalendarLayerView()
        .environmentObject(viewModel)
}
