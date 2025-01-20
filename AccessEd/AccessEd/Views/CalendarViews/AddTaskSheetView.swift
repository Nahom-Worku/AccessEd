//
//  AddTaskSheetView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-19.
//

import SwiftUI

struct AddTaskSheetView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @FocusState private var isTaskFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add Task")
                .font(.title3)
                .bold()
                .foregroundStyle(Color("Text-Colors"))
            
            VStack (alignment: .leading) {
                Text("Add Task Name")
                    .padding(.leading)
                TextField("Enter Task Name", text: $viewModel.TaskTitle)
                    .focused($isTaskFieldFocused)
                    .padding(10)
                    .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                    .padding([.horizontal, .bottom], 20)
                    .font(.subheadline)
            
                Text("Select Date")
                    .padding(.leading)
                DatePicker("Due Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .padding(10)
                    .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                    .padding(.horizontal, 20)
                    .font(.subheadline)
            }
            .foregroundStyle(Color("Text-Colors"))

            
            HStack(alignment: .center) {
                
                // canel bottom sheet button
                Button(action: { viewModel.isAddingTask = false }) {
                    Text("Cancel")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.red)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 100, height: 40)
                                .padding(.horizontal, 20)
                        )
                }
                
                Spacer()
                
                // Add course button
                Button {
                    viewModel.addTask(for: viewModel.selectedDate, name: viewModel.TaskTitle)
                    viewModel.TaskTitle = ""
                    viewModel.isAddingTask = false
                } label: {
                    Text("Add")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                                .frame(width: 100, height: 40)
                                .padding(.horizontal, 20)
                        )
                }
            }
            .padding(.trailing, 7)
            .frame(width: 250)
        }
        .padding()
        .frame(maxWidth: 350, maxHeight: 325)
        .padding(.top, 5)
        .background(
            Color("Courses-Colors")
                .cornerRadius(15)
                .shadow(radius: 1, x: 0, y: 1)
        )
        .padding(.horizontal, 10)
        .padding(.top, 10)
        .onAppear {
            isTaskFieldFocused = true
        }
    }
}

#Preview {
    let viewModel = CalendarViewModel()
    AddTaskSheetView(viewModel: viewModel)
}
