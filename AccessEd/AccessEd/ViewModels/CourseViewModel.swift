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
    
    @Published var inputCourses: [String : Double] = [:]
    @Published var excludeList: [String] = []
    
    
    var recommendedCourses: [CourseModel] {
        let mlOutput: [String] = CoursesRecommender(userPreferences: inputCourses, excludeList: excludeList)
        return mlOutput.map(getCourse)
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
    
//    func addCourseToInput(course: CourseModel) {
//        inputCourses[course.name] = 1.0
//        addCourse(courseName: course.name, category: course.category)
//    }
//    
//    func dismissCourse(course: CourseModel) {
//        if !excludeList.contains(course.name) {
//            excludeList.append(course.name)
//        }
//    }
    
    func fetchInputCourses() {
        guard let context = modelContext else { return }
        let fetchDescriptor = FetchDescriptor<InputCourseModel>()
        let fetchedCourses = (try? context.fetch(fetchDescriptor)) ?? []
        
        inputCourses = Dictionary(uniqueKeysWithValues: fetchedCourses.map { ($0.name, $0.rating) })
    }

    func fetchExcludeList() {
        guard let context = modelContext else { return }
        let fetchDescriptor = FetchDescriptor<ExcludeListModel>()
        let fetchedExcludes = (try? context.fetch(fetchDescriptor)) ?? []
        
        excludeList = fetchedExcludes.map { $0.courseName }
    }

    func addToInputCourses(courseName: String) {
        guard !inputCourses.keys.contains(courseName) else { return }
//        inputCourses[courseName] = 1.0
        let newinputCourse = InputCourseModel(name: courseName, rating: 1.0)
        modelContext?.insert(newinputCourse)
        try? modelContext?.save()
        
        fetchInputCourses()
        fetchCourses()
        
        addCourse(courseName: courseName, category: courseCategoryMap[courseName] ?? .other)
    }

    func addExcludeList(courseName: String) {
        guard let context = modelContext else { return }
        if !excludeList.contains(courseName) {
            let newExclude = ExcludeListModel(courseName: courseName)
            context.insert(newExclude)
            try? context.save()
            fetchExcludeList()
            
            fetchCourses()
        }
    }
}
