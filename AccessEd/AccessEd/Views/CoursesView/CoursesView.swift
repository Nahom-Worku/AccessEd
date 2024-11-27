//
//  CoursesView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-23.
//

import SwiftUI

struct Course: Identifiable {
    let id = UUID()
    var name: String
    var category: String
}

struct CoursesView: View {
    
    @State var showAddCoursesBottomView: Bool = false
    @State var courseName: String = ""
    
    let courseCategories = [
        "Mathematics",
        "Natural Sciences",
        "Social Sciences",
        "Technology and Engineering",
        "Health and Physical Education",
        "Languages",
        "Arts and Humanities",
        "Career and Technical Education",
        "Other"
    ]
    
    @State var coursesList: [Course] = []
    
    @State private var selectedCategory: String = "Mathematics"
    
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack (spacing: 10) {
//                        ForEach(0..<5) { index in
                            // TODO:
                            //      add a function to get the:
                            //                               image for each course
                            //                               title and discription
                            
                            NavigationLink {
                                Text("each courses page")
                            } label: {
                                VStack {
                                    ForEach(coursesList) { course in
                                        EachCourseView(course: course)
                                    }
                                }
                            }
                            
//                        }
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
                                .fill(Color.blue.opacity(0.8))
                                .frame(width: 50)
                                .shadow(radius: 3)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.headline)
                                        .foregroundStyle(.white)
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
        })
    }
    
    var addCourseButtomSheet: some View {
        VStack(spacing: 20) {
            Text("Add a Course")
                .font(.title3)
                .bold()
                .foregroundStyle(Color("Text-Colors"))
            
            VStack (alignment: .leading) {
                Text("Add The Course Name")
                    .padding(.leading)
                
                TextField("Enter Course Name", text: $courseName)
                    .padding(10)
                    .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                    .padding([.horizontal, .bottom], 20)
                    .font(.subheadline)
            
                Text("Select Course Category")
                    .padding(.leading)
               
                Picker("Select Category", selection: $selectedCategory) {
                    ForEach(courseCategories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .padding(5)
                .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                .padding(.leading, 20)
                .font(.subheadline)
            }
            .foregroundStyle(Color("Text-Colors"))

            
            HStack(alignment: .center) {
                
                // canel bottom sheet button
                Button(action: { showAddCoursesBottomView = false }) {
                    Text("Cancel")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.red)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 100, height: 40)
                                .padding(.horizontal, 20)
                        )
                }
                
                Spacer()
                
                // Add course button
                Button {
                    addCourse(name: courseName, category: selectedCategory)
//                    CourseName = ""
                    showAddCoursesBottomView = false
                } label: {
                    Text("Add")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                                .frame(width: 100, height: 40)
                                .padding(.horizontal, 20)
                        )
                }
            }
            .padding(.trailing, 7)
            .frame(width: 250)
        }
        .padding()
        .frame(maxWidth: 350, maxHeight: 325)
        .padding(.top, 5)
        .background(
            Color("Courses-Colors")
                .cornerRadius(15)
                .shadow(radius: 1, x: 0, y: 1)
        )
        .padding(.horizontal, 10)
        .padding(.top, 10)
    }
    
    private func addCourse(name: String, category: String) {
        coursesList.append(Course(name: name, category: category))
    }
    
    private func getCourseImage(category: String) -> Image {
//        switch category {
//        case "Science":
            return Image("science")
//        case "Math":
//            return Image("math")
//        case "History":
//            return Image("history")
//        case "Art":
//            return Image("art")
//        default:
//            
//        }
    }
}

struct EachCourseView: View {
    let course: Course
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(#colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)).opacity(0.8))
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
                        Text(course.name)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Category: \(course.category)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(5)
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .frame(width: 320, alignment: .leading)
                .padding(.trailing, 5)
            )
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
