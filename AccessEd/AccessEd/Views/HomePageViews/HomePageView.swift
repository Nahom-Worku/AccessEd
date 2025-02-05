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
                VStack(spacing: 10) {
                    HStack {
                        Text("AccessEd")
                            .font(.title)
                        
                        Spacer()
                        
                        Image("App Logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70)
                    }
                    .padding()
                    .padding(.top, 50)
                    .frame(maxWidth: 240)
                    
                    // Courses and Calendar Layer
                    VStack(spacing: 10) {
                        CoursesLayerView(courseViewModel: courseViewModel, profileViewModel: profileViewModel, calendarViewModel: calendarViewModel)
                        CalendarLayerView()
                    }
                    .padding(.horizontal, 10)
                    .background(
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 50, topTrailing: 0), style: .continuous)
                            .fill(Color("Light-Dark Mode Colors"))
                    )
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1))]),
                        startPoint: .bottomTrailing,
                        endPoint: .topLeading)
                )
                .padding(.bottom) 
            }
            
            // Overlays
            EachRecommendedCourseCardView(viewModel: courseViewModel)
            if let taskIndex = calendarViewModel.selectedTaskIndex {
                EditTaskView(viewModel: calendarViewModel, taskIndex: taskIndex, isCurrentDateSelected: $isCurrentDateSelected)
            }
        }
        .padding(.leading)
        .edgesIgnoringSafeArea(.top) // Limit to top only
        .background(Color("Light-Dark Mode Colors"))
        .onAppear {
            isCurrentDateSelected = true
        }
        .alert(isPresented: Binding<Bool>(
            get: {
                courseViewModel.showAlert || calendarViewModel.taskAlerts != nil
            },
            set: { newValue in
                if !newValue {
                    courseViewModel.showAlert = false
                    calendarViewModel.taskAlerts = nil
                }
            }
        ), content: {
            if courseViewModel.showAlert {
                return courseViewModel.getAlert()
            } else if let alertType = calendarViewModel.taskAlerts {
                return calendarViewModel.getAlert(alertType: alertType)
            } else {
                return Alert(title: Text("Unknown"))
            }
        })
        .confirmationDialog (
            "Task Actions",
            isPresented: $calendarViewModel.showTaskActions,
            titleVisibility: .visible
        ) {
            Button("Complete All Tasks", role: .none) {
                calendarViewModel.completeAllTasks(for: calendarViewModel.selectedDate)
            }
            Button("Remove All Tasks", role: .destructive) {
                calendarViewModel.deleteAllTasks(for: calendarViewModel.selectedDate)
            }
            Button("Cancel", role: .cancel) {}
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
