//
//  CourseViewModel.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-30.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
class CourseViewModel: ObservableObject {
//    private var modelContext: ModelContext
    @Environment(\.modelContext) var modelContext
    
        @Published var courses: [CourseModel] = []

        init(context: ModelContext) {
//            self.modelContext = context
            getCourses()
        }
        
        func getCourses() {
            do {
                courses = try modelContext.fetch(FetchDescriptor<CourseModel>())
            } catch {
                print("Error fetching courses: \(error)")
            }
        }
        
        func addCourse(course: CourseModel) {
            modelContext.insert(course)
            getCourses() // Refresh the list
        }
        
        func deleteCourse(course: CourseModel) {
            modelContext.delete(course)
            getCourses() // Refresh the list
        }
    
    func moveCourse(from: IndexSet, to: Int) {
        guard let sourceIndex = from.first else {
            print("Error: IndexSet is empty.")
            return
        }

        // Ensure the sourceIndex is within bounds
        guard sourceIndex >= 0 && sourceIndex < courses.count else {
            print("Error: Source index out of range.")
            return
        }

        // Reorder the in-memory courses array
        courses.move(fromOffsets: from, toOffset: to)
        
        getCourses()
    }
    
}

//func deleteCourse(offsets: IndexSet) {
//    coursesList.remove(atOffsets: offsets)
//}
//
//func moveCourse(from source: IndexSet, to destination: Int) {
//    coursesList.move(fromOffsets: source, toOffset: destination)
//}
