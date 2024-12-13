//
//  AccessEdTabView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-23.
//

// SSC Project --> folder

import SwiftUI
import SwiftData

@available(iOS 17.0, *)
struct AccessEdTabView: View {
    
//    @StateObject var courseViewModel: CourseViewModel = CourseViewModel()
    @Environment(\.modelContext) private var modelContext
    
    @State var selectedTab: Int = 0
    let uncompletedTasksForCurrentDate: Int = 3
    
    @Query var allTasks: [Task]
    
    var uncompletedTasks: [Task] {
        allTasks.filter { !$0.completed }
    }
    
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
                CoursesView(viewModel: CourseViewModel(context: modelContext))
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
            .badge(uncompletedTasks.count)
            
            
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

// MARK: don't need the preview for playground

//#Preview("Light Mode") {
//    if #available(iOS 17.0, *) {
//        AccessEdTabView()
//            .preferredColorScheme(.light)
//            .modelContainer(for: CourseModel.self, inMemory: true)
//            .modelContainer(for: Task.self, inMemory: true)
//            .modelContainer(for: CalendarModel.self, inMemory: true)
//    } else {
//        // Fallback on earlier versions
//    }
//}
//
//#Preview("Dark Mode") {
//    if #available(iOS 17.0, *) {
//        AccessEdTabView()
//            .preferredColorScheme(.dark)
//            .modelContainer(for: CourseModel.self, inMemory: true)
//            .modelContainer(for: Task.self, inMemory: true)
//            .modelContainer(for: CalendarModel.self, inMemory: true)
//    } else {
//        // Fallback on earlier versions
//    }
//    
//}
