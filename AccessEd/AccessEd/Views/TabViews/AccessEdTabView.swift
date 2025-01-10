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
    
    let coursesViewModel = CourseViewModel()
    let profileViewModel = ProfileViewModel()
    
    var body: some View {
        
        TabView(selection: $selectedTab) {
            
            // Home page
            VStack {
                HomePageView()
                Spacer().frame(height: 10)
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)
            
            
            // Course page
            VStack {
                CoursesView()
                Spacer().frame(height: 10)
            }
            .tabItem {
                Label("Courses", systemImage: "books.vertical.fill")
            }
            .tag(1)
            
            
            // Calendar/ToDo List page
            VStack {
                CalendarView(viewModel: calendarViewModel)
                Spacer().frame(height: 10)
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            .tag(2)
            .badge(calendarViewModel.uncompletedTasks.count)
            
            
            // Profile page
            VStack {
//                ProfileView()
                ProfileView2()
                Spacer().frame(height: 10)
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
        .modelContainer(for: Task.self, inMemory: true)
        .modelContainer(for: CalendarModel.self, inMemory: true)
}

#Preview("Dark Mode") {
    AccessEdTabView()
        .preferredColorScheme(.dark)
        .modelContainer(for: CourseModel.self, inMemory: true)
        .modelContainer(for: Task.self, inMemory: true)
        .modelContainer(for: CalendarModel.self, inMemory: true)
    
}
