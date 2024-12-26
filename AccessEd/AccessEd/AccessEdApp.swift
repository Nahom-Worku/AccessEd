//
//  AccessEdApp.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-10-25.
//

import SwiftUI
import SwiftData


@main
struct AccessEdApp: App {
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModel = CalendarViewModel()

    var container: ModelContainer = {

        let schema = Schema([
            CourseModel.self,
            CalendarModel.self,
            Task.self,
            ProfileModel.self,
            UserPreferences.self,
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                AccessEdTabView()
                CoursesView()
                CalendarView()
                    .environment(\.modelContext, modelContext)
                    .environmentObject(viewModel)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .modelContainer(container)
    }
}
