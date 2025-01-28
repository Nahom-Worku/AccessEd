//
//  HomePageView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-10-25.
//

import SwiftUI
import SwiftData


struct HomePageView: View {
    @ObservedObject var courseViewModel: CourseViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.modelContext) var modelContext
    @State var isCurrentDateSelected: Bool = false
    
    var body: some View {
        
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HStack {
                        Text("AccessEd")
                            .font(.title)
                        
                        Spacer()
                        
                        Image("App Logo")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                            .clipped()
                    }
                    .padding()
                    .padding(.top, 50)
                    .frame(maxWidth: 240, maxHeight: 150)
  
                    
                    // Courses and Calendar Layer
                    VStack(spacing: 0) {
                        CoursesLayerView(viewModel: courseViewModel, profileViewModel: profileViewModel, calendarViewModel: calendarViewModel)
//                            .frame(height: 290) //300)
                        
                        CalendarLayerView()
//                            .padding()
                    }
//                    .padding(.leading, 10)
                    .frame(width: UIScreen.main.bounds.width /*- 100*/, alignment: .leading)
                    .background(
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 50, topTrailing: 0), style: .continuous)
                            .fill(Color("Light-Dark Mode Colors"))
                    )

                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)).opacity(0.85), Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1))]),
                        startPoint: .trailing,
                        endPoint: .topLeading)
                )
            }
            
            EachRecommendedCourseCardView(viewModel: courseViewModel)
            
            if let taskIndex = calendarViewModel.selectedTaskIndex {
                EditTaskView(viewModel: calendarViewModel, taskIndex: taskIndex, isCurrentDateSelected: $isCurrentDateSelected)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .background(Color("Light-Dark Mode Colors")).ignoresSafeArea(.all)
        .onAppear {
            isCurrentDateSelected = true
        }
        .alert(isPresented: $courseViewModel.showAlert, content: {
            courseViewModel.getAlert()
        })
        .alert(item: $calendarViewModel.taskAlerts) { alertType in
            switch alertType {
            case .removeAllTasks:
                return calendarViewModel.getAlert(alertType: .removeAllTasks)
            case .deleteTask:
                return calendarViewModel.getAlert(alertType: .deleteTask)
            }
        }
    }
}
 
struct HomePageView_Previews: PreviewProvider {
   
    static var previews: some View {
        let profileViewModel = ProfileViewModel()
        let courseViewModel = CourseViewModel(profileViewModel: profileViewModel)
        let calendarViewModel = CalendarViewModel()
//        Group {
        HomePageView(courseViewModel: courseViewModel, calendarViewModel: calendarViewModel ,profileViewModel: profileViewModel)
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
                .environmentObject(courseViewModel)
                .environmentObject(calendarViewModel)
            
        HomePageView(courseViewModel: courseViewModel, calendarViewModel: calendarViewModel ,profileViewModel: profileViewModel)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
                .environmentObject(courseViewModel)
                .environmentObject(calendarViewModel)
//        }
    }
}
