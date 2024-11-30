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
    var courseImage: Image
    var courseColor: Color
}

struct CoursesView: View {
    
    @State var showAddCoursesBottomView: Bool = false
    @State var courseName: String = ""
    @State var coursesList: [Course] = []
    @State private var selectedCategory: String = "Mathematics"
    
    let courseCategories = [
        "Mathematics",
        "Natural Sciences",
        "Social Sciences",
        "Tech & Engineering",
        "Health & PE",
        "Languages",
        "Arts & Humanities",
        "Career & Tech",
        "Other"
    ]
    
   
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(coursesList) { course in
                            NavigationLink {
                                Text("\(course.name) page")
                            } label: {
                                VStack(spacing: 15) {
                                    EachCourseView(course: course)
                                }
                            }
                        }
                    .onDelete(perform: deleteCourse)
                    .onMove(perform: moveCourse)
                    .listRowBackground(Color("List-Colors"))
                }
                
                // Add a Course Button
                addCourseButton
            }
            .navigationTitle("Courses")
        }
        .sheet(isPresented: $showAddCoursesBottomView, content: {
            addCourseButtomSheet
                .presentationDetents([.medium, .fraction(0.5)])
        })
    }
    
    func deleteCourse(offsets: IndexSet) {
        coursesList.remove(atOffsets: offsets)
    }
    
    func moveCourse(from source: IndexSet, to destination: Int) {
        coursesList.move(fromOffsets: source, toOffset: destination)
    }
    
    var addCourseButton: some View {
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
                    if !courseName.isEmpty {
                        addCourse(name: courseName, category: selectedCategory, courseImage: Image(selectedCategory), courseColor: Color(selectedCategory))
                        courseName = ""
                    }
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
    
    func addCourse(name: String, category: String, courseImage: Image, courseColor: Color) {
        coursesList.append(Course(name: name, category: category, courseImage: courseImage, courseColor: courseColor))
    }
}

struct EachCourseView: View {
    let course: Course
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .fill(course.courseColor)
            .padding(.horizontal, 10)
            .frame(width: UIScreen.main.bounds.width - 20, height: 100)
            .padding(.leading)
        
            .shadow(radius: 1, x: 0, y: 1)
            .overlay(
                HStack {
                    course.courseImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75, height: 75)
                        .clipped()
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(course.name)
                            .font(.headline)
                            .foregroundStyle(Color("Text-Colors"))
                        Text("Category: \(course.category)")
                            .font(.footnote)
                            .foregroundStyle(Color("Text-Colors")).opacity(0.5)
                    }
                    .padding(5)
                    .padding(.leading, 5)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundStyle(Color("Text-Colors"))
                }
                .frame(width: 320, alignment: .leading)
                .padding(.leading, 25)
                .padding(.trailing, 10)
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
