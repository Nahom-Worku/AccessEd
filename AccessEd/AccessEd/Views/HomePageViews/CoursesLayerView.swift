//
//  SubjectsLayerView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-02.
//

import SwiftUI
import Foundation

struct CoursesLayerView: View {
    @Environment(\.modelContext) var modelContext
    @ObservedObject var courseViewModel: CourseViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Courses")
                        .font(.title)
                        .bold()
                    
                    Text("Recommendations for you")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                NavigationLink { AllCoursesView(viewModel: courseViewModel) } label: {
                    Text("View All")
                        .font(.subheadline)
                }
                .disabled(courseViewModel.allRecommendedCourses.isEmpty)
            }
            .padding(.top, 15)
            .padding(.horizontal, 15)
            .padding(.trailing, 15)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 20) {
                    RecommendedCoursesView(viewModel: courseViewModel, recommendedCourses: courseViewModel.topSixRecommendedCourses)
                }
                .padding(.top, 20)
                .padding(.vertical, 15)
                .padding(.horizontal, 25)
                .frame(maxHeight: 170)
            }
        }
        .padding(.leading, 5)
        .frame(height: courseViewModel.allRecommendedCourses.isEmpty ? 250 : 280)
        .onAppear {
            profileViewModel.modelContext = modelContext
            courseViewModel.modelContext = modelContext
            profileViewModel.fetchProfile()
            courseViewModel.addPredefinedCoursesToInput(predefinedCourses: profileViewModel.profile?.interestedCourses ?? [])
            courseViewModel.setInterestedCourses(profileViewModel.profile?.interestedCourses ?? [])
            courseViewModel.loadUserPreferences()
            courseViewModel.fetchCourses()
            
            print("Courses Layer view: -> \(profileViewModel.profile?.isNotificationsOn ?? false)")
            scheduleDailyTasksNotification()
            print("\n")
            
        }
    }
    
    private func scheduleDailyTasksNotification() {
        guard profileViewModel.profile?.isNotificationsOn == true else {
            print("Notifications are turned off.")
            return
        }
        
        if calendarViewModel.tasksForCurrentDate.contains(where: { !$0.isCompleted }) {
            let identifier = "dailyTasksReminderForCurrentDay"
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            
            NotificationManager.shared.scheduleNotification (
                at: 20, // 8:00 PM
                minute: 0,
                title: "Daily Tasks Reminder",
                body: "You still have \(calendarViewModel.uncompletedTasksForCurrentDate.count) tasks to complete for today! Check them out before the day ends.",
                identifier: identifier
            )
            
            // MARK: Test notification
//            let now = Date()
//            let calendar = Calendar.current
//
//            let hour = calendar.component(.hour, from: now)
//            let minute = calendar.component(.minute, from: now) + 1 // Add 1 minute for debugging
//
//            NotificationManager.shared.scheduleNotification(
//                at: hour,
//                minute: minute % 60, // Ensure the minute doesn't exceed 59
//                title: "Test Notification",
//                body: "This is a test notification while the app is open.",
//                identifier: "testNotification"
//            )
            
        } else {
            print("All tasks for today are completed.")
        }
    }
}

struct RecommendedCoursesView: View {
    @ObservedObject var viewModel: CourseViewModel
    var recommendedCourses: [CourseModel]
    
    var body: some View {
        if viewModel.allRecommendedCourses.isEmpty {
            VStack(spacing: 10) {
                Image(systemName: "rectangle.on.rectangle.slash")
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
                
                Text("There are no recommendations available")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width - 50)
        }
        else {
            ForEach(recommendedCourses, id: \.id) { course in
                Button {
                    withAnimation(.easeIn(duration: 0.2)) {
                        viewModel.selectedCourse = course
                        viewModel.isCardVisible = true
                    }
                    
                } label: {
//                    VStack {
//                        course.courseImage
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(height: UIScreen.main.bounds.width * 0.25) //100) // 120
//                            .clipped()
//                            .cornerRadius(10)
//                        
//                        Spacer().frame(height: 8)
//                        
//                        VStack(alignment: .center, spacing: 4) {
//                            Text(course.name)
//                                .font(.footnote)
//                                .foregroundColor(.primary)
//                                .multilineTextAlignment(.center)
//                                .lineLimit(nil) // 1
//                                .minimumScaleFactor(0.93)
//                                .padding(5)
//                        }
//                        .padding([.leading, .trailing, .bottom], 8)
//                    }
//                    .frame(maxWidth: UIScreen.main.bounds.width * 0.35, maxHeight: UIScreen.main.bounds.width * 0.33) //150) // 180
//                    .background(Color("Courses-Colors"))
//                    .cornerRadius(15)
//                    .shadow(radius: 3)
                    
                    VStack {
                        course.courseImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 100) // 120
                            .clipped()
                            .cornerRadius(10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text(course.name)
                                .font(.footnote)
                                .foregroundColor(.primary)
                                .padding(5)
                                .lineLimit(1) // Limits text to one line
                                .truncationMode(.tail) // Adds ellipsis at the end if text overflows
                        }
                        .padding([.leading, .trailing, .bottom], 8)
                    }
                    .frame(width: 150) // 180
                    .background(Color("Courses-Colors"))
                    .cornerRadius(15)
                    .shadow(radius: 3)
                }
            }
        }
    }
}

struct AllCoursesView: View {
    @ObservedObject var viewModel: CourseViewModel
    
    var body: some View {
        ZStack {
            if viewModel.allRecommendedCourses.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "rectangle.on.rectangle.slash")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("There are no recommendations available")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .navigationTitle("All Recommended Courses")
            } else {
                ScrollView(.vertical) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 30) {
                        RecommendedCoursesView(viewModel: viewModel, recommendedCourses: viewModel.allRecommendedCourses)
                    }
                    .padding()
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                }
                .navigationTitle("All Courses")
            }
            
            EachRecommendedCourseCardView(viewModel: viewModel)
        }
//        .alert(isPresented: $viewModel.showAlert, content: {
//            viewModel.getAlert()
//        })
    }
}

struct EachRecommendedCourseCardView: View {
    @Environment(\.modelContext) var modelContext
    @ObservedObject var viewModel: CourseViewModel
    
    var body: some View {
        // Overlay for Card View
        if viewModel.isCardVisible {
            Color.black.opacity(0.5) // Dim background
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.isCardVisible = false
                } // Dismiss on tap outside

            LazyVStack {
                HStack {
                    Spacer()
                    
                    Button {
                        viewModel.isCardVisible = false
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                .padding(.horizontal, 3)
                
                Text(viewModel.selectedCourse?.name ?? "")
                    .font(.title3)
                    .bold()
                    .padding()

                Text(NSLocalizedString(viewModel.selectedCourse?.name ?? "", tableName: "CourseInfo", bundle: .main, value: "", comment: ""))
                    .font(.subheadline)
                    .foregroundColor(Color("Text-Colors").opacity(0.8))
                    .padding(.horizontal, 5)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .minimumScaleFactor(0.90)

                Spacer()
                
                HStack {
                    Button {
                        viewModel.alertType = .courseDismissed
                        viewModel.isCardVisible = false
                        viewModel.showAlert = true
                        
                        viewModel.modelContext = modelContext
                        viewModel.loadUserPreferences()
                        viewModel.fetchCourses()
                        
                    } label: {
                        Text("Dismiss")
                            .foregroundStyle(.red)
                    }

                    Spacer()
                    
                    Button {
                        if let course = viewModel.selectedCourse {
                            viewModel.addInputCourse(courseName: course.name)
                        }
                        
                        viewModel.alertType = .courseAdded
                        viewModel.isCardVisible = false
                        viewModel.showAlert = true
                        
                        viewModel.modelContext = modelContext
                        viewModel.loadUserPreferences()
                        viewModel.fetchCourses()
                        
                    } label: {
                        Text("Add")
                            .font(.headline)
                            .foregroundStyle(.green)
                    }
                }
                .padding(.horizontal, 60) // 50
                .frame(width: 300)
                .padding(.top, 30)
            }
            .padding()
            .frame(width: 300) //, height: 340) //UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.35) // 300 , 350
            .background(Color("Courses-Colors").opacity(0.9))
            .cornerRadius(15)
            .shadow(radius: 10, x: 10, y: 10)
            .padding()
        }
    }
}


#Preview("Light Mode") {
    let profileViewModel = ProfileViewModel()
    let viewModel = CourseViewModel(profileViewModel: profileViewModel)
    let calendarViewModel = CalendarViewModel()

    CoursesLayerView(courseViewModel: viewModel, profileViewModel: profileViewModel, calendarViewModel: calendarViewModel)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let profileViewModel = ProfileViewModel()
    let viewModel = CourseViewModel(profileViewModel: profileViewModel)
    let calendarViewModel = CalendarViewModel()
    
    CoursesLayerView(courseViewModel: viewModel, profileViewModel: profileViewModel, calendarViewModel: calendarViewModel)
        .preferredColorScheme(.dark)
}
