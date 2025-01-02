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
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("StudyCard-Colors")) //course.courseColor)
            .padding(.horizontal, 30)
            .padding(.leading)
            .frame(width: UIScreen.main.bounds.width, height: 70) // - 40
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
//                        .padding(.leading, 10)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(course.name): \(resourseCategory.self)") // resourseCategory.rawValue.capitalized
                            .font(.subheadline)
                            .foregroundStyle(Color("Text-Colors"))
                        
                        Text("Resourse Category: \(resourseCategory.self)")
                            .font(.footnote)
                            .foregroundStyle(Color("Text-Colors")).opacity(0.5)
                    }
                    .padding(5)
//                    .padding(.leading, 5)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundStyle(Color("Text-Colors"))
                }
                .padding(.horizontal, 60)
                .frame(width: UIScreen.main.bounds.width, alignment: .leading) // w: 300
                
//                .padding(.leading, 20)
//                .padding(.trailing, 20)
            )
    }
}

//#Preview {
//    EachCourseResoursesView()
//}
