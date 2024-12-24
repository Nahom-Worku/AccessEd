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
            viewModel.modelContext = modelContext
            viewModel.fetchCourses()
        }
    }
}

struct CoursesConextMenu: View {
    var viewModel: CourseViewModel
    var courseCategory: CourseCategory
    
    var body: some View {
       
        VStack {
            Button {
                // add course to course model
                viewModel.addCourse(courseName: "Some Course", category: courseCategory)
            } label: {
                Text("Add")
                    .font(.subheadline)
                    .foregroundStyle(.green)
            }

            Button {
                // add course to course model
                
            } label: {
                Text("Dismiss")
                    .font(.subheadline)
                    .foregroundStyle(.red)
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

            VStack {
                // TODO: replace this text with the name of the course
                Text("A Course") //course)
                    .font(.title)
                    .padding()

                // TODO: replace this text with the description of the course
                Text("Detailed information about A Course. This Course is very nice indeed. wow!") // \(course).")
                    .multilineTextAlignment(.center)

                Spacer()
                
                HStack {
                    // TODO: add the functionality to dismiss the recommended courses
                    Button {
                        viewModel.alertType = .courseDismissed
                        viewModel.showAlert.toggle()
                        viewModel.isCardVisible = false
                    } label: {
                        Text("Dismiss")
                            .foregroundStyle(.red)
                    }

                    Spacer()
                    
                    Button {
                        viewModel.addCourse(courseName: "A Course from view all page", category: .mathematics)
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
                .padding(.top)
            }
            .padding()
            .frame(width: 300, height: 350)
            .background(Color("Courses-Colors").opacity(0.9))
            .cornerRadius(15)
            .shadow(radius: 10, x: 10, y: 10)
            .padding()
        }
    }
}
struct RecommendedCoursesView: View {
    @ObservedObject var viewModel: CourseViewModel
    
    var body: some View {
        ForEach(CourseCategory.allCases, id: \.self) { category in
            Button {
                viewModel.isCardVisible = true
            } label: {
                VStack {
                    Image(category.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 100) // 120
                        .clipped()
                        .cornerRadius(10)
                    
                    VStack(alignment: .center, spacing: 4) {
                        Text(category.rawValue)
                            .font(.footnote)
                            .foregroundColor(.primary)
                            .padding(5)
                    }
                    .padding([.leading, .trailing, .bottom], 8)
                }
                .frame(width: 150) // 180
                .background(Color("Courses-Colors"))
                .cornerRadius(15)
                .shadow(radius: 3)
            }

            
//            .contextMenu(menuItems: {
//                CoursesConextMenu(viewModel: viewModel, courseCategory: category)
//            })
        }
    }
}

// testing this thing
struct CourseCard: View {
    let courseName: String = "Test Courses Info"

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 100)
            Text(courseName)
                .font(.headline)
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
