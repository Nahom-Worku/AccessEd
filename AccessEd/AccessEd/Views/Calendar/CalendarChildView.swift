//
//  CalendarEventsView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-09.
//

import SwiftUI

struct CalendarChildView: View {
    @Binding var currentMonth: Date
    @Binding var tasks: [Task]
    var onDateSelected: (Date) -> Void // Callback to handle date selection

    private let calendar = Calendar.current

    var daysInMonthWithPadding: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: currentMonth),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)),
              let firstDayOfWeek = calendar.dateComponents([.weekday], from: startOfMonth).weekday else {
            return []
        }
        
        let padding = Array<Date?>(repeating: nil, count: firstDayOfWeek - 1)
        let days = range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
        return padding + days
    }

    var body: some View {
        VStack {
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(daysInMonthWithPadding, id: \.self) { date in
                    if let date = date {
                        Button(action: {
                            onDateSelected(date) // Notify parent view when a date is selected
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
                        Text("")
                            .frame(width: 40, height: 40)
                    }
                }
            }
        }
        .padding()
    }
}


//#Preview {
//    CalendarChildView(currentMonth: <#Binding<Date>#>, tasks: <#Binding<[Task]>#>, onDateSelected: <#(Date) -> Void#>)
//}
