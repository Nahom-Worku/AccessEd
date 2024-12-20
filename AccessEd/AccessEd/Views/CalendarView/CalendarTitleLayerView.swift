//
//  CalendarTitleLayerView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-19.
//

import SwiftUI
import SwiftData

struct CalendarTitleLayerView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        HStack {
            Button(action: {
                viewModel.currentMonth = viewModel.calendar.date(byAdding: .month, value: -1, to: viewModel.currentMonth) ?? viewModel.currentMonth
            }) {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundStyle(.blue)
                    .bold()
            }
            
            Spacer()
            
            // Display the current month and year
            Text("\(viewModel.formattedMonth())")
                .font(Font.system(size: 18))
            
            Spacer()
            
            Button(action: {
                viewModel.currentMonth = viewModel.calendar.date(byAdding: .month, value: 1, to: viewModel.currentMonth) ?? viewModel.currentMonth
            }) {
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundStyle(.blue)
                    .bold()
            }
        }
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.fetchTasks()
            
            viewModel.onDateSelected = { date in
                viewModel.selectedDate = date
            }
            
            viewModel.updateDynamicColor = { date in
                viewModel.updateDynamicColor(for: date)
            }
        }
        .padding()
        .padding(.horizontal)
    }
}

#Preview {
     let viewModel = CalendarViewModel()
    CalendarTitleLayerView(viewModel: viewModel)
}
