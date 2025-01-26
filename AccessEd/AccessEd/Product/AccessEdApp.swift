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
    @StateObject var calendarViewModel: CalendarViewModel = CalendarViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var courseViewModel: CourseViewModel

    private let notificationDelegate = NotificationDelegate()
    
    var container: ModelContainer = {

        let schema = Schema([
            CourseModel.self,
            CalendarModel.self,
            TaskModel.self,
            ProfileModel.self,
            UserPreferences.self,
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            print("Error: \(error.localizedDescription)")
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        let profileViewModel = ProfileViewModel()
        _profileViewModel = StateObject(wrappedValue: profileViewModel)
        _courseViewModel = StateObject(wrappedValue: CourseViewModel(profileViewModel: profileViewModel))
        
        NotificationManager.shared.configure()
//        NotificationManager.shared.requestAuthorization()
//        UNUserNotificationCenter.current().delegate = notificationDelegate
//        UNUserNotificationCenter.current().delegate = NotificationManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {

                AppIntroView()
//                OnboardingView()
//                AccessEdTabView()
//
//                CoursesView(viewModel: courseViewModel)  // TODO: might need to get rid of these
//                CalendarView(viewModel: calendarViewModel)
                ProfileView()
                    .environment(\.modelContext, modelContext)
                    .environmentObject(calendarViewModel)
                    .environmentObject(profileViewModel)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .modelContainer(container)
    }
}
