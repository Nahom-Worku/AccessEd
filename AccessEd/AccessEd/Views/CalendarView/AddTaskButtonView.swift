//
//  AddTaskButtonView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-19.
//

import SwiftUI

struct AddTaskButtonView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        VStack {
            Button(action: {
                viewModel.isAddingTask = true
            }, label: {
                Text("Add Task")
                    .font(.caption) // subheadline
                    .foregroundColor(.blue)
                    .padding(10)
            })
        }
        .frame(width: 100, height: 40)
    }
}

#Preview {
    let viewModel = CalendarViewModel()
    AddTaskButtonView(viewModel: viewModel)
}
