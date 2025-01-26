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
  
                    
                    // Courses and Schedule Layer
                    VStack(spacing: 0) {
                        CoursesLayerView(viewModel: courseViewModel, profileViewModel: profileViewModel)
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
            
            if profileViewModel.profile?.isNotificationsOn == true {
                // Daily reminder for uncompleted tasks for the current day
                if calendarViewModel.tasksForCurrentDate.contains(where: { $0.isCompleted == false }) {
                    let identifier = "dailyTasksReminderForCurrentDay"
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
                    
                    NotificationManager.shared.scheduleNotification(
                        at: 20,
                        minute: 0,
                        title: "Daily Tasks Reminder For Today",
                        body: "You still have tasks to complete for today! Check them out before the day ends.",
                        identifier: identifier
                    )
                }
            } else {
                print("Notification is turned off")
            }
        }
        .alert(isPresented: $courseViewModel.showAlert, content: {
            courseViewModel.getAlert()
        })
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
