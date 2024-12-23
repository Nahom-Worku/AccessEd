//
//  BookChaptersView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-21.
//

import SwiftUI

struct BookChaptersView: View {
    @Binding var course: CourseModel
    let bookNumber: Int
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                
                // TODO: this loop would eventually be updated to the number of chapters for each book
                ForEach(0..<12) { chapter in
                    
                    NavigationLink(destination: BookView(course: $course, bookNumber: bookNumber, chapter: chapter)) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("StudyCard-Colors")) //course.courseColor)
                            .padding(.horizontal, 30)
                            .frame(width: UIScreen.main.bounds.width, height: 50) // w: - 40
                            .shadow(radius: 1, x: 1, y: 1)
                            .overlay(
                                HStack {
                                    Text("\(course.name) TextBook \(bookNumber + 1)")
                                        .font(.subheadline)
                                        .foregroundStyle(Color("Text-Colors"))
                                    Text("Chapter \(chapter)")
                                        .font(.footnote)
                                        .foregroundStyle(Color("Text-Colors")).opacity(0.5)
                                    
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.subheadline)
                                        .foregroundStyle(Color("Text-Colors"))
                                }
                                .padding(.horizontal, 55)
                                .frame(width: UIScreen.main.bounds.width)
                            )
                    }
                }
            }
            .padding()
            .padding(.vertical)
        }
        .navigationTitle("TextBook Chapters")
    }
}

//#Preview {
//    BookChaptersView()
//}
