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
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
//        WindowGroup {
////            ContentView()
//            HomePageView()
//        }
//        .modelContainer(sharedModelContainer)
        
        WindowGroup {
            NavigationView {
                AccessEdTabView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(listViewModel)
        }
    }
}
