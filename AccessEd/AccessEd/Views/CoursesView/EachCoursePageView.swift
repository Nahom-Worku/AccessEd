//
//  EachCourseView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-29.
//

import SwiftUI
import PDFKit
import Foundation

enum ResoursesCategory: String, Codable, CaseIterable {
    case textbook = "book.pages"
    case notes = "pencil.and.scribble"
}

enum tabs: String, CaseIterable {
    case Course
    case Resourses
}

struct EachCoursePageView: View {
    
    @State var course: CourseModel
    
    @State private var selectedTab: tabs = .Course
    
    var body: some View {
        VStack {
            Picker("Select the tab", selection: $selectedTab) {
                ForEach(tabs.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            
            Group {
                if selectedTab == .Course {
                    CoursesTabView(course: course)
                } else if selectedTab == .Resourses {
                    ResoursesTabView(course: $course)
                        .background(Color.cyan)
                }
            }
//            .animation(.easeInOut, value: selectedTab)
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle(course.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CoursesTabView: View {
    
    @State var course: CourseModel
    
    var body: some View {
        List {
            
            VStack {
//                Color.green.opacity(0.2).cornerRadius(10)
                
                NavigationLink(destination: StudyCardsView(course: $course, cardNumber: 5)) {
                    Text("Study Cards")
                        .font(.title3)
                        .foregroundStyle(Color.black)
                }
                .navigationTitle(course.name)
                
//                VStack(spacing: 20) {
//                    
//                    ForEach(0..<3) { card in
//                        StudyCards(course: $course, cardNumber: card)
//                    }
//                }
//                .padding()
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("Light-Dark Mode Colors"))
    }
}

struct StudyCardsView: View {
    @Binding var course: CourseModel
    @State var cardNumber: Int
    
    @State private var isFlipped = false // State to track the flip

    var body: some View {
        ZStack {
            // Front Side
            if !isFlipped {
                VStack {
                    Text("Question \(cardNumber + 1)")
                        .font(.title3)
                        .padding(.vertical)
                    
                    Text("What is the answer to the question?")

                }
                .frame(width: 350, height: 200)
                .background(course.courseColor)
                .foregroundStyle(Color("Text-Colors"))
                .cornerRadius(10)
                .shadow(radius: 3, y: 1)
            }
            // Back Side
            else {
                VStack {
                    Text("Answer")
                        .font(.title3)
                        .padding(.vertical)
                    
                    Text("Answer: 10,000")
                }
                .frame(width: 350, height: 200)
                .rotation3DEffect(.degrees(-180), axis: (x: 0, y: 1, z: 0))
                .background(course.courseColor)
                .cornerRadius(10)
                .shadow(radius: 3, y: 1)
            }
        }
        .rotation3DEffect(
            .degrees(isFlipped ? -180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.bouncy(duration: 0.6), value: isFlipped)
        .onTapGesture(count: 2) {
            isFlipped.toggle()
        }
    }
}

struct ResoursesTabView: View {
    @Binding var course: CourseModel
    
    var body: some View {
//        VStack {
                // TODO: this has to be in a ForEach loop
                
               
                List {
                        Section(
                            header:
                                HStack {
                                    Text("TextBooks")
                                }
                                .foregroundColor(.red)
                                .font(.headline)
                        ){
                            NavigationLink(destination: BookChaptersView(course: $course)) {
//                            ForEach(0..<3) { resourse in
                                
                                // TODO: add this in a rounded rectangle
                                EachCourseResoursesView(course: $course, resourseCategory: ResoursesCategory.textbook)
//                            }
                        }
                    }
//                        .listRowBackground(Color("List-Colors"))
//                    .background(Color.white)
                   
                        Section(
                            header:
                                HStack {
                                    Text("Notes")
                                }
                                .foregroundColor(.green)
                                .font(.headline)
                        ){
                            NavigationLink(destination: NotesView()) {
                                
                            // TODO: add this in a rounded rectangle
                            EachCourseResoursesView(course: $course, resourseCategory: ResoursesCategory.notes)
                        }
//                            .listRowBackground(Color("List-Colors"))
//                            .listRowSeparatorTint(Color("List-Colors"))
                    }
                    
                }
                .listStyle(InsetGroupedListStyle()) // Custom list style
                .scrollContentBackground(.hidden)
                .background(Color("Light-Dark Mode Colors")) // Background for the list
                
//                Spacer()
            
//            }
//            .background(Color.red)
//            .frame(width: UIScreen.main.bounds.width)
//            .padding()
        
    }
}


struct EachCourseResoursesView: View {
    @Binding var course: CourseModel
    @State var resourseCategory: ResoursesCategory
    
    var body: some View {
        
//        RoundedRectangle(cornerRadius: 10)
//            .fill(course.courseColor)
//            .padding(.horizontal, 10)
//            .frame(width: UIScreen.main.bounds.width - 40, height: 70)
//            .shadow(radius: 1, x: 0, y: 1)
//            .overlay(
                HStack {
                    Image(systemName: resourseCategory.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .fontWeight(.thin)
                        .frame(width: 30, height: 50)
                        .foregroundStyle(Color("Text-Colors"))
                        .clipped()
                        .cornerRadius(10)
                        .padding(.horizontal, 15)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(resourseCategory.rawValue.capitalized)")
                            .font(.headline)
                            .foregroundStyle(Color("Text-Colors"))
                        Text("Resourse Category: \(resourseCategory.self)")
                            .font(.footnote)
                            .foregroundStyle(Color("Text-Colors")).opacity(0.5)
                    }
                    .padding(5)
//                    .padding(.leading, 5)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundStyle(Color("Text-Colors"))
                }
                .padding(.horizontal, 40)
                .frame(width: UIScreen.main.bounds.width, alignment: .leading) // w: 300
                
//                .padding(.leading, 20)
//                .padding(.trailing, 20)
//            )
    }
}

struct BookChaptersView: View {
    @Binding var course: CourseModel
    
    var body: some View {
        ScrollView {
            VStack {
                
                // TODO: this loop would eventually be updated to the number of chapters for each book
                ForEach(0..<12) { chapter in
                    
                    NavigationLink(destination: BookView(course: $course, chapter: chapter)) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(course.courseColor)
                            .padding(.horizontal, 10)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                            .shadow(radius: 1, x: 0, y: 1)
                            .overlay(
                                HStack {
                                    Text("\(course.name) TextBook")
                                        .font(.headline)
                                        .foregroundStyle(Color("Text-Colors"))
                                    Text("Chapter \(chapter)")
                                        .font(.footnote)
                                        .foregroundStyle(Color("Text-Colors")).opacity(0.5)
                                    
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.headline)
                                        .foregroundStyle(Color("Text-Colors"))
                                }
                                    .frame(width: 300, alignment: .leading)
                                    .padding(.leading, 20)
                                    .padding(.trailing, 20)
                            )
                    }
                }
            }
        }
        .navigationTitle("TextBook Chapters")
    }
}

struct BookView: View {
    @Binding var course: CourseModel
    @State var chapter: Int
    
    var body: some View {
        VStack {
            PDFViewer(pdfName: "EECS 2101 3.0 Fundamentals of Data Structures") //"W1 - PartB - I")
                .background(Color.gray.opacity(0.1))
                .padding()
        }
        .navigationTitle("TextBook")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotesView: View {
    var body: some View {
        VStack {
            PDFViewer(pdfName: "MATH 1014 3.0 Fundamentals of Calculus") //"W1 - PartB - I")
                .background(Color.gray.opacity(0.1))
                .padding()
        }
        .navigationTitle("Notes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PDFViewer: UIViewRepresentable {
    let pdfName: String // Name of the PDF file (without extension)

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true // Automatically adjusts to fit the view

        if let url = Bundle.main.url(forResource: pdfName, withExtension: "pdf") {
            pdfView.document = PDFDocument(url: url) // Load the PDF document
        } else {
            print("Error: Could not load \(pdfName).pdf")
        }

        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        // No update needed for static PDFs
    }
}


#Preview("light mode") {
    EachCoursePageView(course: CourseModel(name: "", category: .allCases.randomElement()!))
        .preferredColorScheme(.light)
}

#Preview("dark mode") {
    EachCoursePageView(course: CourseModel(name: "", category: .allCases.randomElement()!))
        .preferredColorScheme(.dark)
}
