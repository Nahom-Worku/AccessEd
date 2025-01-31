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
        VStack(alignment: .center) {
            TasksHeaderView(viewModel: viewModel)
            TasksView(viewModel: viewModel)
        }
        .padding(.vertical)
    }
}

#Preview {
    let viewModel = CalendarViewModel()
    TasksLayerView(viewModel: viewModel)
}
