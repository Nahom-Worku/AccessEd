//
//  ContentView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-10-25.
//

//import SwiftUI
//import SwiftData
//
//struct ContentView: View {
//    @Query(sort: \CourseModel.id) var courses: [CourseModel]
////    @EnvironmentObject var viewModel: CourseViewModel
//    @Environment(\.modelContext) var modelContext
//    @State private var viewModel: ViewModel
//
//    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(courses) { course in
//                    NavigationLink {
//                        Text("Course: \(course.name)")
//                    } label: {
//                        VStack(alignment: .leading) {
//                            Text(course.name)
//                                .font(.headline)
//                            Text(course.categoryRawValue)
//                                .font(.subheadline)
//                        }
//                    }
//                }
////                .onDelete(perform: deleteCourses)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addSampleCourse) {
//                        Label("Add Course", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select a course")
//        }
//    }
//
//    private func addSampleCourse() {
//        withAnimation {
////            viewModel.addCourse(
////                name: "New Course",
////                category: CourseCategory(rawValue: "General") ?? .mathematics
////            )
//            let course = CourseModel(name: "New Course", category: .mathematics)
//            modelContext.insert(course)
//        }
//    }
//
////    private func deleteCourses(at offsets: IndexSet) {
////        withAnimation {
////            for index in offsets {
////                let course = viewModel.courses[index]
////                viewModel.deleteCourse(course: course)
////            }
////        }
////    }
//    
//    init(modelContext: ModelContext) {
//            let viewModel = ViewModel(modelContext: modelContext)
//            _viewModel = State(initialValue: viewModel)
//        }
//}
//
//extension ContentView {
//    @Observable
//    class ViewModel {
//        var modelContext: ModelContext
//        var courses = [CourseModel]()
//
//        init(modelContext: ModelContext) {
//            self.modelContext = modelContext
//            fetchData()
//        }
//
//        func addSample() {
//            let course = CourseModel(name: "New Course", category: .mathematics)
//            modelContext.insert(course)
//            fetchData()
//        }
//
//        func fetchData() {
//            do {
//                let descriptor = FetchDescriptor<CourseModel>(sortBy: [SortDescriptor(\.id)])
//                courses = try modelContext.fetch(descriptor)
//            } catch {
//                print("Fetch failed")
//            }
//        }
//    }
//}


//#Preview {
//    ContentView()
////        .environmentObject(CourseViewModel(context: ModelContext))
//}
