//
//  MonthlyCalendarView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-08.
//

import SwiftUI

struct MonthlyCalendarView: View {
    let calendar = Calendar.current
    var month: Date

    // Calculate the days in the given month with padding
    var daysInMonthWithPadding: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: month),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month)),
              let firstDayOfWeek = calendar.dateComponents([.weekday], from: startOfMonth).weekday else {
            return []
        }
        
        // Calculate padding based on the weekday of the first day
        let padding = Array<Date?>(repeating: nil, count: firstDayOfWeek - 1)
        let days = range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
        return padding + days
    }

    var body: some View {
        VStack {

            
            // Days of the week header
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 5)
            
            // Calendar grid with padding for alignment
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(daysInMonthWithPadding, id: \.self) { date in
                    if let date = date {
                        Button(action: {
                            // Handle date selection
                            print("Selected date: \(date)")
                        }) {
                            if calendar.isDateInToday(date) {
                                Text("\(calendar.component(.day, from: date))")
                                    .frame(width: 40, height: 40)
                                    .background(Color.red.opacity(0.3))
                                    .cornerRadius(8)
                            }
                            else {
                                Text("\(calendar.component(.day, from: date))")
                                    .frame(width: 40, height: 40)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        
                    } else {
                        // Empty cell for padding
                        Text("")
                            .frame(width: 40, height: 40)
                    }
                }
            }
            
            Spacer()
            
            VStack {

                ListView()
            }
            .padding(.top)
            

        }
        .padding()
    }
}


struct CalendarParentView: View {
    @State private var currentMonth: Date = Date()
    private let calendar = Calendar.current
    
    @State private var showCalendar: Bool = true
    @State private var showToDoList: Bool = false

    var body: some View {
        
        VStack {
            HStack {
                Button(action: {
                    showCalendar = true
                    showToDoList = false
                },label: {
                    Text("Calender")
                })
                
                Spacer()
                
                Button(action: {
                    showToDoList = true
                    showCalendar = false
                },label: {
                    Text("To Do List")
                })
            }
            .padding()
            .padding(.horizontal, 75)
            .font(.headline)
            
            if(showCalendar == true && showToDoList == false) {
                calendarLayerView
                MonthlyCalendarView(month: currentMonth)
            } else if(showCalendar == false && showToDoList == true) {
                ListView()
            }
            
            
        }
    }
    
    var calendarLayerView: some View {
        HStack {
            Button(action: {
                currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
            }) {
                Text("Previous")
            }
            
            Spacer()
            
            // Display the current month and year
            Text("\(formattedMonth())")
                .font(Font.system(size: 20))
            
            Spacer()
            
            Button(action: {
                currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
            }) {
                Text("Next")
            }
        }
        .padding()
    }
    
    // Helper function to format the month for display
    private func formattedMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: currentMonth)
    }
}


struct MonthlyCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CalendarParentView()
        }
        .environmentObject(ListViewModel())
    }
}
