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
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @State var isCurrentDateSelected: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        VStack(spacing: 0) {
                            // Calendar view
                            CalendarTitleLayerView(viewModel: calendarViewModel)
                            Divider()
                                .frame(width: UIScreen.main.bounds.width * 0.75, height: 0.21)
                                .background(Color.gray)
                                .padding(.bottom)
                            CalendarEventsView (viewModel: calendarViewModel)
                        }
                        .frame(width: UIScreen.main.bounds.width - 40, height: 335, alignment: .top)
                        .background(Color("Light-Dark Mode Colors").cornerRadius(15))
                        .shadow(radius: 3, x: 0, y: 1) // color: Color("Text-Colors").opacity(0.3),
                        .padding()
                        
                        // Tasks View
                        TasksLayerView(viewModel: calendarViewModel)
                            .frame(width: UIScreen.main.bounds.width)
                            .padding(.horizontal)
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .sheet(isPresented: $calendarViewModel.isAddingTask, content: {
                        AddTaskSheetView(calendarViewModel: calendarViewModel, profileViewModel: profileViewModel)
                            .presentationDetents([.medium, .fraction(1.1)])
                            .padding(.top)
                    })
                    
                }
                    
                
                if let taskIndex = calendarViewModel.selectedTaskIndex {
                    EditTaskView(calendarViewModel: calendarViewModel, profileViewModel: profileViewModel, taskIndex: taskIndex, isCurrentDateSelected: $isCurrentDateSelected)
                }
            }
            .navigationTitle("My Calendar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring()) {
                            calendarViewModel.isAddingTask = true
                        }
                    }, label: {
                        Image(systemName: "plus")
                            .padding()
                    })
                    .disabled(calendarViewModel.isEditingTask)
                }
            }
        }
        .onAppear {
            calendarViewModel.modelContext = modelContext
            calendarViewModel.fetchTasks()
            calendarViewModel.tasks = calendarViewModel.fetchedTasks
            profileViewModel.fetchProfile()
            
            for date in calendarViewModel.tasks.map({ $0.date }) {
                calendarViewModel.updateDynamicColor(for: date)
            }
            
            calendarViewModel.onDateSelected = { date in
                calendarViewModel.selectedDate = date
            }
            
            calendarViewModel.updateDynamicColor = { date in
                calendarViewModel.updateDynamicColor(for: date)
            }
        }
    }
}

#Preview("Light mode") {
    let calendarViewModel = CalendarViewModel()
    let profileViewModel = ProfileViewModel()
    CalendarView(calendarViewModel: calendarViewModel, profileViewModel: profileViewModel)
        .preferredColorScheme(.light)
        .modelContainer(for: [TaskModel.self, CalendarModel.self], inMemory: true)
}

#Preview("Dark mode") {
    let calendarViewModel = CalendarViewModel()
    let profileViewModel = ProfileViewModel()
    CalendarView(calendarViewModel: calendarViewModel, profileViewModel: profileViewModel)
        .preferredColorScheme(.dark)
        .modelContainer(for: [TaskModel.self, CalendarModel.self], inMemory: true)
}
