//
//  EachCourseView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-29.
//

import SwiftUI

struct EachCoursePageView: View {
    
    @State var course: CourseModel
    
    @State private var selectedTab: String = "Course"
    private let tabs: [String] = ["Course", "Resourses"]
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Select the tab", selection: $selectedTab) {
                    ForEach(tabs, id: \.self) { tab in
                        Text(tab).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                
                Group {
                    if selectedTab == "Course" {
                        CoursesTabView(course: course)
                    } else if selectedTab == "Resourses" {
                        ResoursesTabView(course: course)
                    }
                }
                .animation(.easeInOut, value: selectedTab)
                .padding(.horizontal)
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .principal) { // Customize the title
                        Text(course.name)
                            .font(.title) // Increase the font size
                            .bold()
                    }
                }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CoursesTabView: View {
    
    @State var course: CourseModel
    
    var body: some View {
        ZStack {
            Color.green
            
            VStack(spacing: 30) {
                
                Text("\(course.name)")
                    .font(.title)
                
                Text("\(course.categoryRawValue)")
                    .font(.subheadline)
                
                
                Text("Courses Tab View")
                
                Text("Add pictures of your notes things here")
                
                Text("Convert your notes to PDF")
                
            }
        }
    }
}

struct ResoursesTabView: View {
    
    @State var course: CourseModel
    
    var body: some View {
        ZStack {
            Color.yellow
            
            VStack(spacing: 30) {
                
                Text("Books for \(course.name)")
                    .font(.title)
                
                Text("Resourses Tab View")
                
                Text("Open source Books")
                
                Text("Each Book is divided by its chapters")
                
                Text("Other resourses like: others study notes")
            }
        }
    }
}

#Preview {
    EachCoursePageView(course: CourseModel(name: "", category: .allCases.randomElement()!))
}
