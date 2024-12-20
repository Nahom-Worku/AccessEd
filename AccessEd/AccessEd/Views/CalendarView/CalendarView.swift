//
//  CalendarView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-09.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var viewModel: CalendarViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack {
                        // Calendar view
                        CalendarTitleLayerView(viewModel: viewModel)
                        CalendarEventsView (viewModel: viewModel)
                    }
                    .frame(width: UIScreen.main.bounds.width - 20, height: 300, alignment: .top)
                    .background(Color.gray.opacity(0.05).cornerRadius(20))
                    .padding()
                    
                    // Tasks View
                    TasksLayerView(viewModel: viewModel)
                        .frame(width: UIScreen.main.bounds.width)
                        .padding()
                }
                .frame(width: UIScreen.main.bounds.width)
                .sheet(isPresented: $viewModel.isAddingTask, content: {
                    AddTaskSheetView(viewModel: viewModel)
                        .presentationDetents([.medium, .fraction(0.5)])
                        .padding(.top)
                })
                
            }
            .navigationTitle("My Calendar")
        }
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.fetchTasks()
            
            viewModel.tasks = viewModel.fetchedTasks
            for date in viewModel.tasks.map({ $0.date }) {
                viewModel.updateDynamicColor(for: date)
            }
            
            viewModel.onDateSelected = { date in
                viewModel.selectedDate = date
            }
            
            viewModel.updateDynamicColor = { date in
                viewModel.updateDynamicColor(for: date)
            }
        }
    }
}

#Preview("Light mode") {
    CalendarView()
        .preferredColorScheme(.light)
        .modelContainer(for: [Task.self, CalendarModel.self], inMemory: true)
}

#Preview("Dark mode") {
    CalendarView()
        .preferredColorScheme(.dark)
        .modelContainer(for: [Task.self, CalendarModel.self], inMemory: true)
}
