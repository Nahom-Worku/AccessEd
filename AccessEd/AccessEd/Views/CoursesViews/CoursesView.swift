//
//  CoursesView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-23.
//

import SwiftUI
import SwiftData

struct CoursesView: View {
    @Environment(\.modelContext) var modelContext
    
    @StateObject private var viewModel = CourseViewModel()
    
    @State var showAddCoursesBottomView: Bool = false
    @State var courseName: String = ""
    @State private var selectedCategory: CourseCategory = .mathematics
    @State private var showEditCoursesBottomView: Bool = false
    
    
   
    var body: some View {
        NavigationView {
            ZStack {
                
                // TODO: can possibily do List(courses) { course in 
                List {
                    ForEach(viewModel.courses) { course in
                            NavigationLink {
                                EachCoursePageView(course: course)
                            } label: {
                                VStack(spacing: 15) {
                                    EachCourseView(course: course)
                                }
                            }
                        }
                    .onDelete { IndexSet in
                        for index in IndexSet {
                            viewModel.deleteCourse(course: viewModel.courses[index])
                        }
                    }
                    
                    // TODO: onMove function causing a glich and not working
//                    .onMove(perform: viewModel.moveCourse)
                    
                    .listRowBackground(Color("List-Colors"))
                    .listRowSeparatorTint(Color("List-Colors"))
                }
                .scrollContentBackground(.hidden)
                
                
                
                
                if !viewModel.courses.isEmpty {
                    addCourseButton
                } else {
                    VStack {
                        Image(systemName: "books.vertical")
                            .font(Font.system(size: 60))
                            .padding(5)
                            .foregroundStyle(.gray.opacity(0.8))
                            .fontWeight(.light)
                        
                        Text("No Courses")
                            .font(.title2)
                            .bold()
                            .opacity(0.8)
                        
                        Text("Start adding courses to get started!")
                            .font(.subheadline)
                            .padding(.bottom)
                            .foregroundStyle(.gray)
                        
                        Button(action: {
                            showAddCoursesBottomView = true
                        }, label: {
                            Text("Add Course")
                                .font(.headline)
                        })
                    }
                }
            }
            .navigationTitle("Courses")
        }
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.fetchCourses()
        }
        .sheet(isPresented: $showAddCoursesBottomView, content: {
            addCourseButtomSheet
                .presentationDetents([.medium, .fraction(0.5)])
        })
//        .sheet(isPresented: $showEditCoursesBottomView) {
//            //if let courseToEdit = Binding($courseToEdit) {
//            UpdateCourseSheet(course: Binding(projectedValue: $courseToEdit))
//                    .presentationDetents([.medium, .fraction(0.5)])
////            }
//        }
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
                    ForEach(CourseCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
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
                        
//                        let nextOrder = (courses.last?.order ?? -1) + 1
                        
                        let newCourse = CourseModel(name: courseName, category: selectedCategory)
//                        modelContext.insert(newCourse)
                        viewModel.addCourse(courseName: newCourse.name, category: newCourse.category)
                        
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
    

}

struct EachCourseView: View {
    let course: CourseModel
    
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
                        Text("Category: \(course.category.rawValue)")
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
                .padding(.horizontal, 35)
                .padding(.leading, 15)
                .frame(width: UIScreen.main.bounds.width, alignment: .leading) // 320
            )
    }
}


struct UpdateCourseSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var course: CourseModel
    
    @State private var updateCourse: Bool = false
    
    @State private var tempCourse: CourseModel
        
        init(course: Binding<CourseModel>) {
            self._course = course
            self._tempCourse = State(initialValue: course.wrappedValue)
        }
    
    var body: some View {
        NavigationStack {
//            Form {
                    VStack(spacing: 20) {
                        Text("Update Course")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(Color("Text-Colors"))
                        
                        VStack (alignment: .leading) {
                            Text("Add The Course Name")
                                .padding(.leading)
                            
                            TextField("Enter Course Name", text: $tempCourse.name) //$course.name)
                                .padding(10)
                                .background(Color.gray.opacity(0.05).cornerRadius(5.0))
                                .padding([.horizontal, .bottom], 20)
                                .font(.subheadline)
                        
                            Text("Select Course Category")
                                .padding(.leading)
                            
                            Picker("Select Category", selection: $tempCourse.category) { //$course.category) {
                                ForEach(CourseCategory.allCases, id: \.self) { category in
                                    Text(category.rawValue).tag(category)
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
                            Button(action: {
                                dismiss()
                            }) {
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
                                
//                                self.updateCourse = true
//                                dismiss()
//                                
//                                course.courseImageName = course.category.imageName
//                                course.courseColorName = course.category.colorName
                                course.name = tempCourse.name
                                course.category = tempCourse.category
                                course.courseImageName = tempCourse.category.imageName
                                course.courseColorName = tempCourse.category.colorName
                                
                                dismiss()
                                
                            } label: {
                                Text("Done")
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
//                }
            }
            .navigationTitle("Update Course")
        }
}

#Preview("Light mode") {
//    @Previewable @Environment(\.modelContext) var modelContext
    
    CoursesView() //viewModel: CourseViewModel(context: modelContext))
        
        .preferredColorScheme(.light)
        .modelContainer(for: CourseModel.self, inMemory: true)
}

#Preview("Dark mode") {
//    @Previewable @Environment(\.modelContext) var modelContext
    
    CoursesView() //viewModel: CourseViewModel(context: modelContext))
        .preferredColorScheme(.dark)
        .modelContainer(for: CourseModel.self, inMemory: true)
}

