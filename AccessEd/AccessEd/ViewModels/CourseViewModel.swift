//
//  CourseViewModel.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-30.
//

import Foundation
import SwiftData


class CourseViewModel : ObservableObject {
    var modelContext: ModelContext? = nil
    @Published var courses: [CourseModel] = []
    
    func fetchCourses() {
        let fetchDescriptor = FetchDescriptor<CourseModel>(
            predicate: #Predicate {
                $0.name != "Secret course"
            },
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
}
