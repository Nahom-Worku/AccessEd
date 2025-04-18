//
//  AccessEdTabView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-23.
//

import SwiftUI
import SwiftData

struct AccessEdTabView: View {
    
    @StateObject private var calendarViewModel = CalendarViewModel()
    @Environment(\.modelContext) private var modelContext
    
    // TODO: might need to get rid of this variable
    @State var selectedTab: Int = 0
    
    @StateObject var coursesViewModel: CourseViewModel
    @StateObject var profileViewModel = ProfileViewModel()
    
    init() {
        let profileViewModel = ProfileViewModel()
        _profileViewModel = StateObject(wrappedValue: profileViewModel)
        _coursesViewModel = StateObject(wrappedValue: CourseViewModel(profileViewModel: profileViewModel))
    }
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            // Home page
            VStack {
                HomePageView(courseViewModel: coursesViewModel, calendarViewModel: calendarViewModel, profileViewModel: profileViewModel)
                
//                Spacer().frame(height: 10)
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)
            
            
            // Course page
            VStack {
                CoursesView(viewModel: coursesViewModel)
                
//                Spacer().frame(height: 10)
            }
            .tabItem {
                Label("Courses", systemImage: "books.vertical.fill")
            }
            .tag(1)
            
            
            // Calendar/ToDo List page
            VStack {
                CalendarView(calendarViewModel: calendarViewModel, profileViewModel: profileViewModel)
                
//                Spacer().frame(height: 10)
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            .tag(2)
            .badge(calendarViewModel.uncompletedTasks.count)
            
            
            // Profile page
            VStack {
                ProfileView(courseViewModel: coursesViewModel, profileViewModel: profileViewModel, calendarViewModel: calendarViewModel)
                
//                Spacer().frame(height: 10)
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
            .tag(3)
        }
        .environmentObject(calendarViewModel)
    }
}

#Preview("Light Mode") {
    AccessEdTabView()
        .preferredColorScheme(.light)
        .modelContainer(for: CourseModel.self, inMemory: true)
        .modelContainer(for: TaskModel.self, inMemory: true)
        .modelContainer(for: CalendarModel.self, inMemory: true)
}

#Preview("Dark Mode") {
    AccessEdTabView()
        .preferredColorScheme(.dark)
        .modelContainer(for: CourseModel.self, inMemory: true)
        .modelContainer(for: TaskModel.self, inMemory: true)
        .modelContainer(for: CalendarModel.self, inMemory: true)
    
}
