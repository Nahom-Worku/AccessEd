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
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        
    }()
    
    @Environment(\.modelContext) private var modelContext2
    
    var body: some Scene {
        //        WindowGroup {
        ////            ContentView()
        //            HomePageView()
        //        }
        //        .modelContainer(sharedModelContainer)
        
        WindowGroup {
            NavigationView {
                AccessEdTabView()
                CoursesView(viewModel: CourseViewModel(context: modelContext))
                    .environment(\.modelContext, modelContext)
//                    .environmentObject(CourseViewModel(context: modelContext))
//                    .modelContainer(for: [CourseModel.self])
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .modelContainer(container)
        
    }
    
}

//struct AppContentView: View {
//    @Environment(\.modelContext) private var modelContext
//
//    var body: some View {
//        ContentView()
//            .environmentObject(CourseViewModel(context: modelContext)) // Inject the view model
//    }
//}
