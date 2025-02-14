//
//  EachCourseResoursesView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-21.
//

import SwiftUI

struct EachCourseResoursesView: View {
    @Binding var course: CourseModel
    @State var resourseCategory: ResoursesCategory
    @StateObject var profileViewModel = ProfileViewModel()
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(course.courseColor) //Color("StudyCard-Colors"))
            .padding(.horizontal, 30)
            .padding(.leading)
            .frame(width: UIScreen.main.bounds.width, height: 70)
            .shadow(radius: 1, x: 0, y: 1)
            .overlay(
                HStack {
                    Image(systemName: resourseCategory.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .fontWeight(.thin)
                        .frame(width: 35, height: 35)
                        .foregroundStyle(Color("Text-Colors"))
                        .clipped()
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                    

                    Text("\(course.name): \(resourseCategory.self)")
                        .font(.subheadline)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color("Text-Colors"))
                        .padding(5)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundStyle(Color("Text-Colors"))
                }
                .padding(.horizontal, 60)
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            )
    }
}
