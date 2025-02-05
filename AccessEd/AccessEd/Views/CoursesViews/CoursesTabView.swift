//
//  CoursesTabView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-21.
//

import SwiftUI

struct CoursesTabView: View {
    
    @State var course: CourseModel
    
    var body: some View {
        List {
            Section(header: Text("Study Cards")) {
                NavigationLink(destination: StudyCardsView() ){ // course: $course/*, cardNumber: 5*/)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("StudyCard-Colors")) //course.courseColor)
                        .padding(.horizontal, 30)
                        .padding(.leading)
                        .frame(width: UIScreen.main.bounds.width, height: 75)
                        .shadow(radius: 1, x: 0, y: 1)
                        .overlay(
                            HStack {
                                Image(systemName: "rectangle.fill.on.rectangle.angled.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(Color.gray.opacity(0.5)) //Color("StudyCard-Colors"))
                                    .scaledToFit()
                                    .padding()
                                
                                Text("Study Cards")
                                    .font(.headline)
                                    .foregroundStyle(Color("Text-Colors"))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                            .padding(.horizontal, 60)
                    )
                }
                .listRowBackground(Color("Light-Dark Mode Colors"))
            }
            
            Section(header: Text("Quiz")) {
                NavigationLink(destination: QuizView()) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("StudyCard-Colors")) //course.courseColor)
                        .padding(.horizontal, 30)
                        .padding(.leading)
                        .frame(width: UIScreen.main.bounds.width, height: 75)
                        .shadow(radius: 1, x: 0, y: 1)
                        .overlay(
                            HStack {
                                Image(systemName: "rectangle.fill.on.rectangle.angled.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(Color.gray.opacity(0.5)) //Color("StudyCard-Colors"))
                                    .scaledToFit()
                                    .padding()
                                
                                Text("Quiz")
                                    .font(.headline)
                                    .foregroundStyle(Color("Text-Colors"))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                            }
                            .padding(.horizontal, 60)
                    )
                }
                .listRowBackground(Color("Light-Dark Mode Colors"))
            }
            .navigationTitle(course.name)
        }
        .listStyle(InsetGroupedListStyle())
        .scrollContentBackground(.hidden)
        .background(Color("Light-Dark Mode Colors"))
    }
}

//#Preview {
//    CoursesTabView()
//}
