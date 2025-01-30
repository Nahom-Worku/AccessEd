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
        VStack {
            Button(action: {
                viewModel.showTaskActions = true
            }, label: {
                Image(systemName: "ellipsis")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 10)
            })
        }
        .frame(width: 80, alignment: .trailing)
    }
}

#Preview {
    let viewModel = CalendarViewModel()
    TaskActionsView(viewModel: viewModel)
}
