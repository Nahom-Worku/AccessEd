//
//  AddTaskButtonView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-19.
//

import SwiftUI

struct TaskActionsView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack(alignment: .trailing) {
            Button(action: {
                viewModel.showTaskActions = true
            }, label: {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(viewModel.tasksForSelectedDate.isEmpty ? .gray : .blue)
                    .padding(.horizontal, 10)
            })
            .frame(width: 30, height: 30)
            .disabled(viewModel.tasksForSelectedDate.isEmpty)
        }
    }
}

#Preview {
    let viewModel = CalendarViewModel()
    TaskActionsView(viewModel: viewModel)
}
