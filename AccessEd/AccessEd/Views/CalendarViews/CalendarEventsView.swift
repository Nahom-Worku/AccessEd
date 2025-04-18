//
//  CalendarEventsView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-09.
//

import SwiftUI

struct CalendarEventsView: View {
    @ObservedObject var viewModel: CalendarViewModel
    private let calendar = Calendar.current

    var body: some View {
        VStack {
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.footnote) // .caption
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 5)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(viewModel.daysInMonthWithPadding.indices, id: \.self) { index in
                    if let date = viewModel.daysInMonthWithPadding[index] {
                        // Filter tasks for this specific cell's date
                        let cellTasks = viewModel.tasks.filter { calendar.isDate($0.date, inSameDayAs: date) }
                        let cellUncompletedTasks = cellTasks.filter { !$0.isCompleted }
                        
                        let hasTasks = !cellTasks.isEmpty
                        let isCompleted = !cellTasks.isEmpty && cellUncompletedTasks.isEmpty

                        let isSelected = calendar.isDate(date, inSameDayAs: viewModel.selectedDate)
                        let isToday = calendar.isDateInToday(date)

                        // Get stored color if any
                        let storedColorName = viewModel.getColorForDate(date) ?? "clear"
                        let storedColor = Color.fromString(storedColorName) //.opacity(0.025)

                        // Determine final background color based on conditions
                        let backgroundColor: Color = {
                            
                            // TODO: update this if statement so that the bg color is updated as expected
                            if isToday {
                                return Color("Today-Color") // Today
                            } else if hasTasks && !isCompleted {
                                return Color.red.opacity(0.3) // Incomplete tasks
                            } else if hasTasks && isCompleted {
                                return Color.green.opacity(0.4) // All tasks completed
                            } else {
                                return storedColor // Stored or default color
                            }
                        }()


                        Button(action: {
                            viewModel.onDateSelected?(date)
                            viewModel.updateDynamicColor?(date)
                        }) {
                            let dayNumber = calendar.component(.day, from: date)
                            let textValue = isToday ? "•\(dayNumber)•" : "\(dayNumber)"
                            
                            Text(textValue)
                                .font(.footnote)
                                .bold(hasTasks && !isCompleted)
//                                .fontWeight(isToday && hasTasks && !isCompleted ? .heavy : .regular)
                                .frame(width: 35, height: 35, alignment: .center) // 30, 30
                                .background(backgroundColor)
                                .foregroundStyle(isToday ? Color.white : Color("Text-Colors"))
                                .cornerRadius(10) // 8
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(isSelected ? Color("SelectedDate-Color") : .clear, lineWidth: hasTasks ? 5 : 3)
                                .frame(width: 35, height: 35, alignment: .center)
                        )
                        .buttonStyle(PlainButtonStyle())
                    } else {
                        Text("") // Empty cell for padding days
                            .frame(width: 35, height: 35)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

