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
                    .foregroundStyle(.gray)
                    .bold()
            }
            .frame(width: 30, height: 30)
//            .padding(3)
            .background(Color("Light-Dark Mode Colors"))
            .clipShape(RoundedCornerShape(corners: .allCorners, radius: 5))
//            .shadow(radius: 1)
            
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
                    .foregroundStyle(.gray)
                    .bold()
            }
            .frame(width: 30, height: 30)
//            .padding(3)
            .background(Color("Light-Dark Mode Colors"))
            .clipShape(RoundedCornerShape(corners: .allCorners, radius: 5))
//            .shadow(radius: 1)
        }
        .padding()
        .padding(.horizontal)
//        .background(
////            LinearGradient(
////                gradient: Gradient(colors: [Color("Light-Dark Mode Colors"), Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)).opacity(0.3)]),
////                startPoint: .bottom,
////                endPoint: .top)
////            Color.gray.opacity(0.5)
//        )
//        .clipShape( RoundedCornerShape(corners: [.topLeft, .topRight], radius: 20))
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
    }
}

struct RoundedCornerShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
     let viewModel = CalendarViewModel()
    CalendarTitleLayerView(viewModel: viewModel)
}
