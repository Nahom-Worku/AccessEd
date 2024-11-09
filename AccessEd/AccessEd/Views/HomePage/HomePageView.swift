//
//  HomePageView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-10-25.
//

import SwiftUI

struct HomePageView: View {
    
    @State var showAddSubjectSheet: Bool = false
    
    var body: some View {
        
        
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    
                    // Perview Layer
                    ZStack {
                        emptyPreviewLayer
                    }
                    .frame(height: 200)
                    
                    
                    // Subjects and Schedule Layer
                    VStack {
                        SubjectsLayerView(showAddSubjectSheet: $showAddSubjectSheet)
                        
                        ScheduleLayerView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 30, topTrailing: 0), style: .continuous)
                            .fill(Color.white)
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1))]),
                        startPoint: .leading,
                        endPoint: .trailing)
                )
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color.white)
            .sheet(isPresented: $showAddSubjectSheet) {
                AddCourseSheet()
                    .presentationDetents([.medium, .fraction(0.5)])
                    .background(Color.white)
                    .cornerRadius(50)
                    .ignoresSafeArea(.all)
            }
            
            // Bottom Tab bar placeholders
            BottomMenuView()
        }
    }
    
    
    var emptyPreviewLayer: some View {
        HStack {
            Text("AccessEd")
                .font(.largeTitle)
            
            Spacer()
            
            Image("education")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 150)
                .clipped()
        }
        .padding()
        .padding(.top, 50)
        .frame(maxWidth: 320, maxHeight: 150)
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
    
    var body: some View {
        
        VStack (alignment: .center) {
            Text("Enter Course Information")
                .font(Font.system(size: 20))
                .padding()
                .padding(.top, 10)
            
            TextField("Enter Course Name", text: $courseName)
                .padding(10)
                .background(Color.white.cornerRadius(10.0))
                .padding(.horizontal, 20)
                .foregroundStyle(Color.black)
                .font(.subheadline)
//                .font(.subheadline)
//                .padding(.horizontal)
//                .padding(.vertical, 10)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Choose Category", text: $grade)
                .padding(10)
                .background(Color.white.cornerRadius(10.0))
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .foregroundStyle(Color.black)
                .font(.subheadline)
//                .font(.subheadline)
//                .padding(.horizontal)
//                .padding(.bottom, 10)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
            
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
            .foregroundStyle(Color.black)
        }
        .frame(maxWidth: 300, maxHeight: 250)
        .padding()
        .padding(.vertical, 10)
        .background(
            Color.gray.opacity(0.1)
                .cornerRadius(15)
                .shadow(
                    color: Color.black.opacity(0.3),
                    radius: 5,
                    x: 0.0,
                    y: 10 )
        )
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
        
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomePageView()
        }
        .environmentObject(ListViewModel()) 
    }
}
