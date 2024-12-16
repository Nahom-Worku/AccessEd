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

    var container: ModelContainer = {

        let schema = Schema([
            CourseModel.self,
            CalendarModel.self,
            Task.self,
            ProfileModel.self,
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
                CoursesView(viewModel: CourseViewModel(context: modelContext))
                    .environment(\.modelContext, modelContext)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .modelContainer(container)
    }
}
