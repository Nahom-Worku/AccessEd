//
//  CourseViewModel.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-30.
//

import Foundation
import SwiftData
import SwiftUI

class CourseViewModel : ObservableObject {
    var modelContext: ModelContext? = nil
    @Published var courses: [CourseModel] = []
    @Published var selectedCourse: CourseModel? = nil
    @Published var isCardVisible: Bool = false
    @Published var alertType: CourseAlerts? = nil
    @Published var showAlert: Bool = false
    
    @Published var interestedCourses: [String] = []
    
    var defaultWeight: Double = 1.0
    
    @Published var userPreferences: UserPreferences?
    
    private let profileViewModel: ProfileViewModel
    
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        loadUserPreferences()
    }
    
    var allRecommendedCourses: [CourseModel] {
        var mlOutput: [String] = []

        if let userPreferences = userPreferences {
            var unfilteredCourses: [String] = []

            // Step 1: Fetch recommendations from the ML model
            unfilteredCourses = CoursesRecommender(userPreferences: userPreferences.inputCourses, excludeList: userPreferences.excludeList)

            // Step 2: Filter out courses already in inputCourses or excludeList
            unfilteredCourses = unfilteredCourses.filter { courseName in
                let alreadyInInput = userPreferences.inputCourses.keys.contains(courseName)
                let inExcludeList = userPreferences.excludeList.contains(courseName)
                return !(alreadyInInput || inExcludeList)
            }

            // Step 3: Filter courses based on fields of interest
            if let fieldsOfInterest = profileViewModel.profile?.fieldsOfInterest {
                let allowedCourses = fieldsOfInterest.flatMap { category in
                    CourseCategory.coursesByField[category] ?? []
                }
                
                unfilteredCourses = unfilteredCourses.filter { courseName in
                    allowedCourses.contains(courseName)
                }
            }

            // Step 4: Assign final filtered list to mlOutput
            mlOutput = unfilteredCourses
        }

        // Step 5: Convert filtered course names into CourseModel objects
        return mlOutput.map { courseName in
            getCourse(courseName: courseName)
        }
    }
    
    var topSixRecommendedCourses: [CourseModel] { return Array(allRecommendedCourses.prefix(6)) }
    
    
    func setInterestedCourses(_ courses: [String]) {
        self.interestedCourses = courses
    }
    
    func fetchCourses() {
        let fetchDescriptor = FetchDescriptor<CourseModel>(
            sortBy: [SortDescriptor(\.createdDate)]
        )
        courses = (try? (modelContext?.fetch(fetchDescriptor) ?? [])) ?? []
    }
    
    func addCourse(courseName: String, category: CourseCategory) {
        let newCourse = CourseModel(name: courseName, category: category)
        modelContext?.insert(newCourse)
        try? modelContext?.save()
        
        fetchCourses()
    }
    
    func deleteCourse(course: CourseModel) {
        modelContext?.delete(course)
        try? modelContext?.save()
        
        fetchCourses()
    }
    
    func deleteAllCourses() {
        // Delete courses from SwiftData
        for course in courses {
            modelContext?.delete(course)
        }

        do {
            try modelContext?.save() // Persist the deletions
            courses.removeAll() // Clear the local array
            fetchCourses()
        } catch {
            print("Error deleting courses: \(error.localizedDescription)")
        }
    }
    
    // MARK: - TODO:- might need to add a deleteAllCourses() function
    
//    func moveCourse(from: IndexSet, to: Int) {
    //        guard let sourceIndex = from.first else {
    //            print("Error: IndexSet is empty.")
    //            return
    //        }
    //
    //        // Ensure the sourceIndex is within bounds
    //        guard sourceIndex >= 0 && sourceIndex < courses.count else {
    //            print("Error: Source index out of range.")
    //            return
    //        }
    //
    //        // Reorder the in-memory courses array
    //        courses.move(fromOffsets: from, toOffset: to)
    //
    //        getCourses()
    //    }
    
    //func moveCourse(from source: IndexSet, to destination: Int) {
    //    coursesList.move(fromOffsets: source, toOffset: destination)
    //}
    
    func getAlert() -> Alert {
        switch alertType {
        case .courseAdded:
            return Alert(title: Text("Course Added"), message: Text("Your course has been added"))
        case .courseDismissed:
            return Alert(title: Text("Course Dismissed"), message: Text("Your course has been dismissed"))
        default:
            return Alert(title: Text("Error"), message: Text("Something went wrong"))
        }
    }
    
    func getCourse(courseName: String) -> CourseModel {
        if let category = CourseCategory.map[courseName] {
            return CourseModel(name: courseName, category: category)
        } else {
            return CourseModel(name: courseName, category: .other)
        }
    }
    
    func loadUserPreferences() {
        guard let modelContext = modelContext else {
            print("Model context is not available.")
            return
        }

        let fetchDescriptor = FetchDescriptor<UserPreferences>()
        
        if let existingPreferences = try? modelContext.fetch(fetchDescriptor).first {
            userPreferences = existingPreferences
        } else {
            let newPreferences = UserPreferences()
            modelContext.insert(newPreferences)
            try? modelContext.save()
            userPreferences = newPreferences
        }
        
        fetchCourses()
    }
    
    func addPredefinedCoursesToInput(predefinedCourses: [String]) {
        guard let preferences = userPreferences else { return }
        for course in predefinedCourses {
            if preferences.inputCourses[course] == nil {
                preferences.inputCourses[course] = defaultWeight
            }
        }
        saveUserPreferences()
        fetchCourses()
    }
    
    func addInputCourse(courseName: String, weight: Double = 1.0) {
        guard let preferences = userPreferences else { return }
        preferences.inputCourses[courseName] = weight
        addCourse(courseName: courseName, category: CourseCategory.map[courseName] ?? .other)
        fetchCourses()
        saveUserPreferences()
    }

    func addToExcludeList(courseName: String) {
        guard let preferences = userPreferences else { return }
        if !preferences.excludeList.contains(courseName) {
            preferences.excludeList.append(courseName)
            saveUserPreferences()
        }
    }

    func saveUserPreferences() {
        try? modelContext?.save()
    }
    
    func clearUserPreferences() {
        guard let modelContext = modelContext else {
            print("Model context is not available.")
            return
        }

        // Fetch the UserPreferences instance
        let fetchDescriptor = FetchDescriptor<UserPreferences>()
        
        if let preferencesToDelete = try? modelContext.fetch(fetchDescriptor).first {
            // Delete the fetched UserPreferences instance
            modelContext.delete(preferencesToDelete)
            do {
                // Save the context to persist changes
                try modelContext.save()
                userPreferences = nil // Clear the local reference
                print("User preferences cleared successfully.")
            } catch {
                print("Error saving after deleting user preferences: \(error)")
            }
        } else {
            print("No UserPreferences data found to delete.")
        }
    }
    
    func clearAllRecommendedCourses() {
        
        // MARK: - Need to update this
        
        if let userPreferences = userPreferences {
            // Clear the input courses and exclude list
            userPreferences.inputCourses.removeAll()
            userPreferences.excludeList.removeAll()
            
//            predefinedCourses.removeAll()

            // Save the changes to the model using SwiftData
            do {
                try modelContext?.save()
            } catch {
                print("Error saving changes: \(error.localizedDescription)")
            }
        }
        // `allRecommendedCourses` will automatically reflect the changes as it's computed.
        fetchCourses()
    }

    func resetUserPreferences() {
        userPreferences?.inputCourses = [:]
        userPreferences?.excludeList = []
        fetchCourses()
        saveUserPreferences()
    }
}
