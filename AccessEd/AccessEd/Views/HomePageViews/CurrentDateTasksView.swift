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
                TasksSubView(viewModel: viewModel)
            }
            .padding(.top, 10)
            .padding(.trailing, 30)
            .frame(width: UIScreen.main.bounds.width)
        }
    }
}
