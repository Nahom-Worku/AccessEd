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
    
    // TODO: add this so that each course would have different bg color
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
        "Technology and Engineering",
        "Health and Physical Education",
        "Languages",
        "Arts and Humanities",
        "Career and Technical Education",
        "Other"
    ]
    
   
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    LazyVStack (spacing: 10) {
                        ForEach(coursesList) {course in
                            NavigationLink {
                                Text("\(course.name) page")
                            } label: {
                                VStack(spacing: 15) {
                                    EachCourseView(course: course)
                                }
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
                    if !courseName.isEmpty {
                        addCourse(name: courseName, category: selectedCategory, courseImage: getCourseImage(category: selectedCategory), courseColor: getCourseColor(category: selectedCategory))
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
    
    func getCourseImage(category: String) -> Image {
        
        switch category {
        case "Mathematics":
            return Image("Geometry")
            
        case "Natural Sciences":
            return Image("science")
            
        case "Social Sciences":
            return Image("Social-Sciences")
            
        case "Technology and Engineering":
            return Image("Tech-and-Eng")
            
        case "Health and Physical Education":
            return Image("Health-and-Physical-Education")
            
        // MARK: need to come up with the image for this category
        case "Languages":
            return Image(systemName: "apple.logo")
            
        case "Arts and Humanities":
            return Image("Arts-Humanities")
            
        case "Career and Technical Education":
            return Image("Business-Finance")
            
        // MARK: also need to come up with the image for this category
        case "Other":
            return Image(systemName: "book.fill")
            
        default:
            return Image(systemName: "book.fill")
        }
    }
    
    public func getCourseColor(category: String) -> Color {
        
        switch category {
        case "Mathematics":
            return Color(hex: "#87CEFA")//Color(#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1))
            
        case "Natural Sciences":
            return Color(hex: "#1E90FF")//Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1))
            
        case "Social Sciences":
            return Color(hex: "#FF7F50")//Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
            
        case "Technology and Engineering":
            return Color(hex: "#00008B")//Color(#colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1))
            
        case "Health and Physical Education":
            return Color(hex: "#32CD32")//Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1))
            
        // MARK: need to come up with the image for this category
        case "Languages":
            return Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))
            
        case "Arts and Humanities":
            return Color(hex: "#8A2BE2")//Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1))
            
        case "Career and Technical Education":
            return Color(hex: "#FFD700")//Color(#colorLiteral(red: 0.5810584426, green: 0.1285524964, blue: 0.5745313764, alpha: 1))
            
        // MARK: also need to come up with the image for this category
        case "Other":
            return Color(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1))
            
        default:
            return Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        }
    }
}

struct EachCourseView: View {
    let course: Course
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .fill(course.courseColor.opacity(0.5))
            .padding(.horizontal, 20)
            .frame(width: UIScreen.main.bounds.width, height: 100)
            .shadow(radius: 1, x: 0, y: 1)
            .overlay(
                HStack {
                    course.courseImage
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 75, height: 75)
                        .clipped()
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(course.name)
                            .font(.headline)
                            .foregroundStyle(Color("Text-Colors"))
                        Text("Category: \(course.category)")
                            .font(.subheadline)
                            .foregroundStyle(Color("Text-Colors")).opacity(0.5)
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
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        
        let r = Double((hexNumber & 0xff0000) >> 16) / 255.0
        let g = Double((hexNumber & 0x00ff00) >> 8) / 255.0
        let b = Double(hexNumber & 0x0000ff) / 255.0
        
        self.init(red: r, green: g, blue: b)
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
