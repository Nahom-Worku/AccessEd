//
//  SubjectsLayerView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-02.
//

import SwiftUI

struct CoursesLayerView: View {
    @Environment(\.modelContext) var modelContext
    @ObservedObject var viewModel: CourseViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Courses")
                        .font(.title)
                        .bold()
                    
                    Text("Recommendations for you")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                NavigationLink { AllRecommendedCoursesView(viewModel: viewModel) } label: {
                    Text("View All")
                        .font(.subheadline)
                }
            }
            .padding(.top, 15)
            .padding(.horizontal, 10)
            
            ScrollView(.horizontal ,showsIndicators: true) {
                HStack(alignment: .center, spacing: 20) {
                    RecommendedCoursesView(viewModel: viewModel)
                }
                .frame(maxHeight: 300)
            }
            .padding(.leading, 10) // 15
        }
        .padding()
        .onAppear {
            viewModel.inputCourses["Chemistry"] = 1.0
            viewModel.modelContext = modelContext
//            viewModel.fetchInputCourses()
//            viewModel.fetchExcludeList()
            viewModel.fetchCourses()
        }
    }
}

struct RecommendedCoursesView: View {
    @ObservedObject var viewModel: CourseViewModel
    
    var body: some View {
        ForEach(viewModel.recommendedCourses, id: \.id) { course in
            Button {
                viewModel.selectedCourse = course
                viewModel.isCardVisible = true
            } label: {
                VStack {
                    course.courseImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: UIScreen.main.bounds.width * 0.26) //100) // 120
                        .clipped()
                        .cornerRadius(10)
                        
                    VStack(alignment: .center, spacing: 4) {
                        Text(course.name)
                            .font(.footnote)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil) // 1
                            .minimumScaleFactor(0.93)
                            .padding(5)
                    }
                    .padding([.leading, .trailing, .bottom], 8)
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.35, maxHeight: UIScreen.main.bounds.width * 0.35) //150) // 180
                .background(Color("Courses-Colors"))
                .cornerRadius(15)
                .shadow(radius: 3)
            }
        }
    }
}

struct AllRecommendedCoursesView: View {
    @ObservedObject var viewModel: CourseViewModel
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 30) {
                    RecommendedCoursesView(viewModel: viewModel)
                }
                .padding()
                .padding(.top, 10)
                .padding(.horizontal, 20)
            }
            .navigationTitle("All Recommended Courses")
            
            EachRecommendedCourseCardView(viewModel: viewModel)
        }
        .alert(isPresented: $viewModel.showAlert, content: {
            viewModel.getAlert()
        })
    }
}

struct EachRecommendedCourseCardView: View {
    @ObservedObject var viewModel: CourseViewModel
    
    var body: some View {
        // Overlay for Card View
        if viewModel.isCardVisible {
            Color.black.opacity(0.5) // Dim background
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.isCardVisible = false
                } // Dismiss on tap outside

            LazyVStack {
                Text(viewModel.selectedCourse?.name ?? "")
                    .font(.title3)
                    .bold()
                    .padding()

                Text(NSLocalizedString(viewModel.selectedCourse?.name ?? "", tableName: "CourseInfo", bundle: .main, value: "", comment: ""))
                    .font(.subheadline)
                    .foregroundColor(Color("Text-Colors").opacity(0.8))
                    .padding(.horizontal, 5)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .minimumScaleFactor(0.90)

                Spacer()
                
                HStack {
                    // TODO: add the functionality to dismiss the recommended courses
                    Button {
                        if let courseName = viewModel.selectedCourse?.name {
//                            viewModel.addExcludeList(courseName: courseName)
                            viewModel.excludeList.append(courseName)
                        }
                        print("input courses: \(viewModel.inputCourses)")
                        print("excluded courses: \(viewModel.excludeList)")
                        
                        viewModel.alertType = .courseDismissed
                        viewModel.isCardVisible = false
                        viewModel.showAlert = true //.toggle()
                    } label: {
                        Text("Dismiss")
                            .foregroundStyle(.red)
                    }

                    Spacer()
                    
                    Button {
                        if let course = viewModel.selectedCourse {
//                            viewModel.addToInputCourses(courseName: course.name)
                            viewModel.inputCourses[course.name] = 1.0
                            viewModel.addCourse(courseName: course.name, category: viewModel.courseCategoryMap[course.name] ?? .other)
                        }
                        print("input courses: \(viewModel.inputCourses)")
                        print("excluded courses: \(viewModel.excludeList)")
                        
                        viewModel.alertType = .courseAdded
                        viewModel.isCardVisible = false
                        viewModel.showAlert = true
                    } label: {
                        Text("Add")
                            .font(.headline)
                            .foregroundStyle(.green)
                    }
                }
                .padding(.horizontal, 60) // 50
                .frame(width: 300)
                .padding(.top, 30)
            }
            .padding()
            .frame(width: 300) //, height: 340) //UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.35) // 300 , 350
            .background(Color("Courses-Colors").opacity(0.9))
            .cornerRadius(15)
            .shadow(radius: 10, x: 10, y: 10)
            .padding()
        }
    }
}


#Preview("Light Mode") {
    let viewModel = CourseViewModel()
    CoursesLayerView(viewModel: viewModel)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let viewModel = CourseViewModel()
    CoursesLayerView(viewModel: viewModel)
        .preferredColorScheme(.dark)
}
