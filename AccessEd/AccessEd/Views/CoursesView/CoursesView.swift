//
//  CoursesView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-23.
//

import SwiftUI

struct CoursesView: View {
    var body: some View {
        ScrollView {
            LazyVStack (spacing: 10) {
                ForEach(0..<5) { index in
                    // TODO:
//                         add a function to get the:
//                                                  image for each course
//                                                  title and discription
                    
                    NavigationLink {
                        Text("each courses page")
                    } label: {
                        eachCourseView
                    }

                }
            }
            .padding(.top)
        }
        .navigationTitle("Courses")
    }
    
    var eachCourseView: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(#colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)))
            .padding(.horizontal, 20)
            .frame(width: UIScreen.main.bounds.width, height: 100)
            .overlay(
                HStack {
                    Image("science")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75, height: 75)
                        .clipped()
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Biology")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Chapter 3: Animal Kingdom")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                        Text("2:00 PM - 3:00 PM")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(5)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .frame(width: 330, alignment: .leading)
                .padding(.trailing, 5)
            )
    }
}

#Preview {
    CoursesView()
}
