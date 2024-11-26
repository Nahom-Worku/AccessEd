//
//  AccessEdTabView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-23.
//

import SwiftUI

struct AccessEdTabView: View {
    
    @State var selectedTab: Int = 0
    let uncompletedTasksForCurrentDate: Int = 3
    
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
                CalendarView()
                Spacer().frame(height: 10)
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            .tag(2)
            .badge(uncompletedTasksForCurrentDate)
            
            
            // Profile page
            VStack {
                ProfileView()
                Spacer().frame(height: 10)
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
            .tag(3)
        }
    }
}

#Preview("Light Mode") {
    AccessEdTabView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    AccessEdTabView()
        .preferredColorScheme(.dark)
}
