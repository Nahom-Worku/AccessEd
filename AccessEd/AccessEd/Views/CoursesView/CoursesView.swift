//
//  CoursesView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-23.
//

import SwiftUI

struct CoursesView: View {
    
    @State var showAddCoursesBottomView: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack (spacing: 10) {
                        ForEach(0..<7) { index in
                            // TODO:
                            //      add a function to get the:
                            //                               image for each course
                            //                               title and discription
                            
                            NavigationLink {
                                Text("each courses page")
                            } label: {
                                eachCourseView
                            }
                            
                        }
                    }
                    .padding(.top)
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        // add courses button
                        Button(action: {
                            showAddCoursesBottomView = true
                        }) {
                            Circle()
                                .fill(Color.white.opacity(0.5))
                                .stroke(Color.white, lineWidth: 1)
                                .frame(width: 60)
                                .shadow(radius: 3)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.largeTitle)
                                        .foregroundStyle(.black.opacity(0.8))
                                )
                                .padding()
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                    .padding(.trailing)
                }
            }
            .navigationTitle("Courses")
        }
        .sheet(isPresented: $showAddCoursesBottomView, content: {
            addCourseButtomSheet
                .presentationDetents([.medium, .fraction(0.5)])
                .background(Color.gray.opacity(0.1))
        })
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
                .frame(width: 320, alignment: .leading)
                .padding(.trailing, 5)
            )
    }
    
    var addCourseButtomSheet: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Users can add their own courses here")
            
            Text("Course Name")
            
            Text("Course Category")
        }
        .font(.headline)
        .padding(.top)
        .frame(width: 350, height: 350)
    }
}

#Preview("Light mode") {
    CoursesView()
        .preferredColorScheme(.light)
}

#Preview("Dark mode") {
    CoursesView()
        .preferredColorScheme(.dark)
}
