//
//  EachCourseView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-29.
//

import SwiftUI
import PDFKit


struct EachCoursePageView: View {
    
    @State var course: CourseModel
    
    @State private var selectedTab: String = "Course"
    private let tabs: [String] = ["Course", "Resourses"]
    
    var body: some View {
        VStack {
            Picker("Select the tab", selection: $selectedTab) {
                ForEach(tabs, id: \.self) { tab in
                    Text(tab).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            
            Group {
                if selectedTab == "Course" {
                    CoursesTabView(course: course)
                } else if selectedTab == "Resourses" {
                    ResoursesTabView(course: $course)
                }
            }
            .animation(.easeInOut, value: selectedTab)
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
        ZStack {
            Color.green.opacity(0.2).cornerRadius(10)
            
            VStack(spacing: 30) {
                
                StudyCards(course: $course)
                    .frame(width: 300, height: 200)
                    .cornerRadius(10)
                
                Text("Courses Tab View")
                
                Text("Add pictures of your notes things here")
                
                Text("Convert your notes to PDF")
                
            }
        }
    }
}

struct StudyCards: View {
    @Binding var course: CourseModel
    
    @State private var isFlipped = false // State to track the flip

    var body: some View {
        ZStack {
            // Front Side
            if !isFlipped {
                VStack {
                    Text("Question for \(course.name) course")
                        .font(.headline)
                        .padding(5)
                    
                    Text("What is the answer to the question?")

                }
                .frame(width: 300, height: 150)
                .background(Color("Courses-Colors"))
                .foregroundStyle(Color("Text-Colors"))
                .cornerRadius(10)
                .shadow(radius: 3, y: 1)
            }
            // Back Side
            else {
                VStack {
                    Text("Answer for the question")
                        .font(.headline)
                    
                    Text("Answer: 10,000")
                }
                .frame(width: 300, height: 150)
                .rotation3DEffect(.degrees(-180), axis: (x: 0, y: 1, z: 0))
                .background(Color("Courses-Colors"))
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
            isFlipped.toggle() // Toggle the flip state
        }
    }
}

struct ResoursesTabView: View {
    
    @Binding var course: CourseModel
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.1).cornerRadius(10)
            
            VStack(spacing: 30) {
                      
                // TODO: this has to be in a ForEach loop
                
                NavigationLink(destination: BookView()) {
                    EachCourseResoursesView(course: $course)
                }
                
                
                Text("Books for \(course.name)")
                    .font(.title)
                
                Text("Resourses Tab View")
                
                Text("Open source Books")
                
                Text("Each Book is divided by its chapters")
                
                Text("Other resourses like: others study notes")
                
                Spacer()
            }
            .padding()
        }
    }
}

struct EachCourseResoursesView: View {
    @Binding var course: CourseModel
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .fill(course.courseColor)
            .padding(.horizontal, 10)
            .frame(width: UIScreen.main.bounds.width - 40, height: 80)
//            .padding(.leading)
        
            .shadow(radius: 1, x: 0, y: 1)
            .overlay(
                HStack {
                    Image(systemName: "book.pages")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .fontWeight(.thin)
                        .frame(width: 40, height: 60)
                        .foregroundStyle(Color("Text-Colors"))
                        .clipped()
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(course.name) TextBook")
                            .font(.headline)
                            .foregroundStyle(Color("Text-Colors"))
                        Text("Resourse Category: TextBook")
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
                .frame(width: 300, alignment: .leading)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            )
    }
}

struct BookView: View {
    var body: some View {
//        NavigationView {
            VStack {
                PDFViewer(pdfName: "W1 - PartB - I")
                    .background(Color.gray.opacity(0.1))
                    .padding()
            }
            .navigationTitle("TextBook")
            .navigationBarTitleDisplayMode(.inline)
//        }
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
