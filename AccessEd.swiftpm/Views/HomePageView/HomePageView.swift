//
//  HomePageView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-10-25.
//

import SwiftUI
import SwiftData


@available(iOS 17.0, *)
struct HomePageView: View {
    
    @Query var profile: [ProfileModel]
        
    var body: some View {
        
//        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    
                    // Perview Layer
                    ZStack {
//                        emptyPreviewLayer
                        if !profile.isEmpty {
                            Text("The profile has been set up")
                        } else {
                            emptyPreviewLayer
                        }
                        
                    }
                    .frame(height: 150)
                    
                    
                    // Courses and Schedule Layer
                    VStack(spacing: 0) {
                        CoursesLayerView()
                            .frame(height: 300)
                        
//                        ScheduleLayerView()
//                            .frame(minHeight: 200)
                        
                        CalendarLayerView()
                            .frame(minHeight: 100)
                    }
                    .padding(.leading, 10)
                    .background(
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 50, topTrailing: 0), style: .continuous)
                            .fill(Color("Light-Dark Mode Colors"))
                    )
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1))]),
                        startPoint: .bottomTrailing,
                        endPoint: .topLeading)
                )
            }
            .edgesIgnoringSafeArea(.top)
            .background(Color("Light-Dark Mode Colors")).ignoresSafeArea(.all)

            
            // Bottom Tab bar placeholders
//            BottomMenuView()
//        }
        
    }
    
    
    var emptyPreviewLayer: some View {
        HStack {
            Text("AccessEd")
                .font(.title)
            
            Spacer()
            
            Image("education")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 70)
                .clipped()
        }
        .padding()
        .padding(.top, 50)
        .frame(maxWidth: 240, maxHeight: 150)
    }
    
    var nonEmptyPreviewLayer: some View {
        VStack {
            Text("You have tasks in your To-Do List")
                .font(.headline)
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .padding()
                .frame(width: .infinity, height: 120)
                .padding(.top, 60)
        )
    }
    
}


struct AddCourseSheet: View {
    @State private var courseName: String = ""
    @State private var grade: String = ""
    
    @Environment(\.dismiss) var dismissScreen
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack (alignment: .center) {
            Text("Enter Course Information")
                .font(Font.system(size: 20))
                .padding()
                .padding(.top, 10)
            
            TextField("Enter Course Name", text: $courseName)
                .padding(10)
                .background(colorScheme == .light ? .white : .gray.opacity(0.1))
                .cornerRadius(10.0)
                .padding(.horizontal, 20)
                .foregroundStyle(Color.white)
                .font(.subheadline)
            
            TextField("Choose Category", text: $grade)
                .padding(10)
                .background(colorScheme == .light ? .white : .gray.opacity(0.1))
                .cornerRadius(10.0)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .foregroundStyle(Color.white)
                .font(.subheadline)
            
            
            // Buttons
            HStack {
                
                // Cancel button
                Button {
                    dismissScreen()
                } label: {
                    Text("Canel")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.red.opacity(0.6))
                                .frame(width: 120, height: 40)
                        )
                }

                Spacer()
                
                // Add course button
                Button {
                    
                } label: {
                    Text("Add")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue.opacity(0.6))
                                .frame(width: 120, height: 40)
                        )
                }
            }
            .padding()
            .frame(maxWidth: 240, maxHeight: 100)
        }
        .frame(maxWidth: 300, maxHeight: 250)
        .padding()
        .padding(.vertical, 10)
        .background(colorScheme == .light ? .gray.opacity(0.2) : Color(#colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)).opacity(0.5))
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
        
    }
}

//#Preview("Light Mode") {
//    HomePageView()
//        .preferredColorScheme(.light)
//}
//
//#Preview("Dark Mode") {
//    HomePageView()
//        .preferredColorScheme(.dark)
//}

@available(iOS 17.0, *)
struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomePageView()
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
            
            HomePageView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}
