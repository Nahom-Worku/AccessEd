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
    @State var isCurrentDateSelected: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        VStack(spacing: 0) {
                            // Calendar view
                            CalendarTitleLayerView(viewModel: viewModel)
                            Divider()
                                .frame(width: UIScreen.main.bounds.width * 0.75, height: 0.21)
                                .background(Color.gray)
                                .padding(.bottom)
                            CalendarEventsView (viewModel: viewModel)
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 335, alignment: .top)
                        .background(Color("Light-Dark Mode Colors").cornerRadius(15))
                        .shadow(radius: 3, x: 0, y: 1) // color: Color("Text-Colors").opacity(0.3),
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
                    
                
                if let taskIndex = viewModel.selectedTaskIndex {
                    EditTaskView(viewModel: viewModel, taskIndex: taskIndex, isCurrentDateSelected: $isCurrentDateSelected)
                }
            }
            .navigationTitle("My Calendar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring()) {
                            viewModel.isAddingTask = true
                        }
                    }, label: {
                        Image(systemName: "plus")
                            .padding()
                    })
                    .disabled(viewModel.isEditingTask)
                }
            }
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
