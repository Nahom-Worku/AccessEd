//
//  TasksLayerHeaderView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-19.
//

import SwiftUI

struct TasksHeaderView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "checklist")
            Text("Tasks for")
                .font(.subheadline)
            Text("\(viewModel.formattedDate(viewModel.selectedDate))")
                .font(.headline)
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
            
            AddTaskButtonView(viewModel: viewModel)
        }
        .frame(width: UIScreen.main.bounds.width - 50, alignment: .leading)
        .padding(.leading, 30)
    }
}

#Preview {
    let viewModel = CalendarViewModel()
    TasksHeaderView(viewModel: viewModel)
}
