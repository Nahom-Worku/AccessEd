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
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack {
                        // Calendar view
                        CalendarTitleLayerView(viewModel: viewModel)
                        CalendarEventsView (viewModel: viewModel)
                    }
                    .frame(width: UIScreen.main.bounds.width - 40, height: 310, alignment: .top)
                    .background(Color("Light-Dark Mode Colors").cornerRadius(20))
                    .shadow(radius: 1, x: 0, y: 0) // color: Color("Text-Colors").opacity(0.3),
                    .padding()
                    
                    // Tasks View
                    TasksLayerView(viewModel: viewModel)
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.horizontal)
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
    let viewModel = CalendarViewModel()
    CalendarView(viewModel: viewModel)
        .preferredColorScheme(.light)
        .modelContainer(for: [TaskModel.self, CalendarModel.self], inMemory: true)
}

#Preview("Dark mode") {
    let viewModel = CalendarViewModel()
    CalendarView(viewModel: viewModel)
        .preferredColorScheme(.dark)
        .modelContainer(for: [TaskModel.self, CalendarModel.self], inMemory: true)
}
