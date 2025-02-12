//
//  CurrentDateTasksView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-19.
//

import SwiftUI

struct CurrentDateTasksView: View {
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var isCurrentDateSelected: Bool = false
    @State var isNavigatingToCalendar: Bool = false
    
    var body: some View {
        VStack {
            if calendarViewModel.tasksForCurrentDate.isEmpty {
//                Text("No tasks for today.")
//                    .foregroundColor(.gray)
//                    .padding(.top, 50)
//                    .frame(width: UIScreen.main.bounds.width, alignment: .center)
                
                VStack(alignment: .center) {
                    Image(systemName: "list.bullet.rectangle")
                        .font(Font.system(size: 40))
                        .padding(5)
                        .foregroundStyle(.gray.opacity(0.8))
                        .fontWeight(.light)
                    
                    Text("No tasks for today.")
                        .font(.headline)
                        .bold()
                        .opacity(0.8)
                        .padding(.bottom, 5)
                    
                    Text("Start adding tasks to get started in the Calendar Page!")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.bottom)
                        .padding(.horizontal, 50)
                        .multilineTextAlignment(.center)
                                        
                    
                    // MARK: - TODO: change this deprecated ting
//                    NavigationLink(
//                        destination: CalendarView(calendarViewModel: calendarViewModel), // ✅ Properly push the view
//                        isActive: $isNavigatingToCalendar
//                    ) {
//                        Button(action: {
//                            calendarViewModel.selectedDate = Date()
//                            withAnimation {
//                                calendarViewModel.isAddingTask = true
//                                isNavigatingToCalendar = true
//                            }
//                        }, label: {
//                            Text("Add a Task")
//                                .font(.subheadline)
//                        })
//                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding()
                .padding(.vertical)
                .padding(.bottom, 30)
                
            } else {
                LazyVStack(alignment: .center, spacing: 5) {
                    TasksSubView(viewModel: calendarViewModel, isCurrentDateSelected: $isCurrentDateSelected)
                }
                .padding(.top, 10)
                .padding(.trailing, 20)
            }
        }
        .onAppear {
            isCurrentDateSelected = true
        }
    }
}
