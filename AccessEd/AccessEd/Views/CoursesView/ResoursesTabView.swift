//
//  ResoursesTabView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-21.
//

import SwiftUI

struct ResoursesTabView: View {
    @Binding var course: CourseModel
    
    var body: some View {
//        VStack {
                // TODO: this has to be in a ForEach loop
               
        List {
            Section(
                header:
                    HStack {
                        Text("TextBooks")   // TODO: might need to get rid of the HStack
                    }
                    .foregroundColor(.purple)
                    .font(.headline)
            ){
                ForEach(0..<3) { index in
                    NavigationLink(destination: BookChaptersView(course: $course, bookNumber: index)) {
                        
                        // TODO: add this in a rounded rectangle
                        EachCourseResoursesView(course: $course, resourseCategory: ResoursesCategory.textbook)
                    }
                }
            }
            
            Section(
                header:
                    HStack {
                        Text("Notes")   // TODO: might need to get rid of the HStack
                    }
                    .foregroundColor(.green)
                    .font(.headline)
            ){
                NavigationLink(destination: NoteView()) {
                    
                    // TODO: add this in a rounded rectangle --> some sort of loop as well
                    EachCourseResoursesView(course: $course, resourseCategory: ResoursesCategory.notes)
                }
            }
            
            Section(
                header:
                    HStack {
                        Text("Assignments")   // TODO: might need to get rid of the HStack
                    }
                    .foregroundColor(.blue)
                    .font(.headline)
            ){
                NavigationLink(destination: NoteView()) {   // TODO: change this destination to --> AssignmentsView()
                    
                    // TODO: add this in a rounded rectangle --> some sort of loop as well
                    EachCourseResoursesView(course: $course, resourseCategory: ResoursesCategory.assignment)
                }
            }
            
            Section(
                header:
                    HStack {
                        Text("Exams")   // TODO: might need to get rid of the HStack
                    }
                    .foregroundColor(.orange)
                    .font(.headline)
            ){
                NavigationLink(destination: NoteView()) {   // TODO: change this destination to --> ExamView()
                    
                    // TODO: add this in a rounded rectangle --> some sort of loop as well
                    EachCourseResoursesView(course: $course, resourseCategory: ResoursesCategory.exam)
                }
            }
        }
        .listStyle(InsetGroupedListStyle()) // Custom list style
        .scrollContentBackground(.hidden)
        .background(Color("Light-Dark Mode Colors")) // Background for the list
    }
}

//#Preview {
//    ResoursesTabView()
//}
