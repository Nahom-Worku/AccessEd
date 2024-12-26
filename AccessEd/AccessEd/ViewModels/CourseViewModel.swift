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
    @Published var alertType: MyAlerts? = nil
    @Published var showAlert: Bool = false
    
    let courseCategoryMap: [String: CourseCategory] = [
        "Language Arts": .artsAndHumanities,
        "History": .artsAndHumanities,
        "Philosophy": .artsAndHumanities,
        "Religious Studies": .artsAndHumanities,
        "Visual and Performing Arts": .artsAndHumanities,
        
        "Geography": .socialSciences,
        "Economics": .socialSciences,
        "Political Science": .socialSciences,
        "Psychology": .socialSciences,
        "Sociology": .socialSciences,
        
        "Biology": .naturalSciences,
        "Chemistry": .naturalSciences,
        "Physics": .naturalSciences,
        "Earth Science": .naturalSciences,
        "Environmental Science": .naturalSciences,
        
        "Arithmetic": .mathematics,
        "Algebra": .mathematics,
        "Geometry": .mathematics,
        "Calculus": .mathematics,
        "Statistics": .mathematics,
        
        "Information Technology": .techAndEngineering,
        "Engineering": .techAndEngineering,
        "Robotics": .techAndEngineering,
        "Computer Science": .techAndEngineering,
        
        "Agricultural Education": .careerAndTech,
        "Business Education": .careerAndTech,
        "Trade Skills": .careerAndTech,
        "Culinary Arts": .careerAndTech,
    ]
    
    let predefinedCourses: [String] = ["Physics", "Calculus", "History"]
    let defaultWeight: Double = 1.0
    
    @Published var userPreferences: UserPreferences?
    
    var recommendedCourses: [CourseModel] {
        var mlOutput: [String] = []
        
        if let userPreferences = userPreferences {
            mlOutput = CoursesRecommender(userPreferences: userPreferences.inputCourses, excludeList: userPreferences.excludeList)
        }
        
        return mlOutput.map(getCourse)
    }
    
    
    init() {
        loadUserPreferences()
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
        if let category = courseCategoryMap[courseName] {
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
    }
    
    func addPredefinedCoursesToInput() {
        guard let preferences = userPreferences else { return }
        for course in predefinedCourses {
            if preferences.inputCourses[course] == nil {
                preferences.inputCourses[course] = defaultWeight
            }
        }
        saveUserPreferences()
    }
    
    func addInputCourse(courseName: String, weight: Double = 1.0) {
        guard let preferences = userPreferences else { return }
        preferences.inputCourses[courseName] = weight
        addCourse(courseName: courseName, category: courseCategoryMap[courseName] ?? .other)
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

    func resetUserPreferences() {
        userPreferences?.inputCourses = [:]
        userPreferences?.excludeList = []
        saveUserPreferences()
    }
}
