//
//  TasksLayerView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-19.
//

import SwiftUI

struct TasksLayerView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            TasksHeaderView(viewModel: viewModel)
            TasksView(viewModel: viewModel)
        }
        .padding()
    }
}

#Preview {
    let viewModel = CalendarViewModel()
    TasksLayerView(viewModel: viewModel)
}
