//
//  EachCourseView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-29.
//

import SwiftUI
import Foundation

struct EachCoursePageView: View {
    
    @State var course: CourseModel
    
    @State private var selectedTab: tabs = .Course
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("Select the tab", selection: $selectedTab) {
                ForEach(tabs.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .padding(.horizontal)
            
            
            Group {
                if selectedTab == .Course {
                    CoursesTabView(course: course)
                } else if selectedTab == .Resourses {
                    ResoursesTabView(course: $course)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle(course.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("light mode") {
    EachCoursePageView(course: CourseModel(name: "", category: .allCases.randomElement()!))
        .preferredColorScheme(.light)
}

#Preview("dark mode") {
    EachCoursePageView(course: CourseModel(name: "", category: .allCases.randomElement()!))
        .preferredColorScheme(.dark)
}
