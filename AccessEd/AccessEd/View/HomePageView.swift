//
//  HomePageView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-10-25.
//

import SwiftUI

struct HomePageView: View {
    
    @State private var showAddSubjectSheet: Bool = false
    
    var body: some View {
        
        ScrollView(.vertical) {
            
            VStack {
                
                // Perview Layer
                ZStack {
                    emptyPreviewLayer
                }
                .frame(height: 260)
                
                
                // Subjects and Schedule Layer
                VStack {
                    subjectsLayer
                    
                    scheduleLayer
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: 50, topTrailing: 0), style: .continuous)
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
        bottomMenu
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
                .frame(width: 350, height: 200)
                .padding(.top, 60)
        )
    }
    
    var subjectsLayer: some View {
        VStack(alignment: .leading) {
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Subjects")
                        .font(.title)
                        .bold()
                    
                    Text("Recommendations for you")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        
                }
                .padding(.horizontal)
                .padding(.bottom, 15)
                
                Spacer()
                
                // Add courses button
                Button {
                    self.showAddSubjectSheet = true
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "plus")
                        
                        Text("Add")
                            
                    }
                    .font(.caption)
                    .bold()
                    .foregroundColor(.gray)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                            .frame(width: 70, height: 30)
                    )
                }
            }
            .padding(.top, 15)
            .padding(.trailing, 15)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    // Mathematics
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.orange)
//                        .stroke(Color.black, lineWidth: 1)
                        .frame(width: 150, height: 120)
                        
                        .overlay(
                            VStack {
                                HStack {
                                    Image(systemName: "x.squareroot")
                                    
                                    Spacer()
                                    
                                    Image(systemName: "ellipsis.circle")
                                    
                                }
                                .font(Font.system(size: 20))
                                
                                
                                Spacer()
                                
                                Text("Mathematics")
                                    .font(.headline)
                            }
                            .padding()
//                            .frame(width: 150, height: 120)
                            .foregroundStyle(Color.black)
                        )
                    
                    
                    // Chemistry
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue.opacity(0.8))
                        .frame(width: 150, height: 120)
                        .overlay(
                            VStack {
                                HStack {
                                    Image(systemName: "atom")
                                    
                                    Spacer()
                                    
                                    Image(systemName: "ellipsis.circle")
                                    
                                }
                                .font(Font.system(size: 20))
                                
                                
                                Spacer()
                                
                                Text("Chemistry")
                                    .font(.headline)
                            }
                            .padding()
                            .foregroundColor(.white)
                        )
                    
                    // Geography
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.brown)
                        .frame(width: 150, height: 120)
                        .overlay(
                            VStack {
                                HStack {
                                    Image(systemName: "globe.europe.africa.fill")
                                    
                                    Spacer()
                                    
                                    Image(systemName: "ellipsis.circle")
                                    
                                }
                                .font(Font.system(size: 20))
                                
                                
                                Spacer()
                                
                                Text("Geography")
                                    .font(.headline)
                            }
                            .padding()
                            .foregroundStyle(Color.white)
                        )
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }
    
    
    var scheduleLayer: some View {
        VStack(alignment: .leading){
            // Your Schedule Section
            
            Text("Your Schedule")
                .font(.title)
                .bold()
            
            Text("Next lessons")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 15)
            
            
            
            // Biology Schedule card
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.green)
                .frame(height: 120)
                .overlay(
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Biology")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Chapter 3: Animal Kingdom")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                            Text("2:00 PM - 3:00 PM")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding()
                        
                        Spacer()
                    }
                )

            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .frame(height: 120)
                .overlay(
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Chemistry")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Chapter 4: Organic Chemistry")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                            Text("3:00 PM - 4:00 PM")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding()
                        
                        Spacer()
                    }
                )

            
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1))]),
                        startPoint: .leading,
                        endPoint: .trailing)
                )
                .frame(height: 120)
                .overlay(
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Geography")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Chapter 4: Organic Chemistry")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                            Text("3:00 PM - 4:00 PM")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding()
                        
                        Spacer()
                    }
                )
            
        }
        .padding()
        .padding(.horizontal)
    }
    
    var bottomMenu: some View {
        HStack(alignment: .center, spacing: 70) {
            Button(action: {
                
            }, label: {
                Image(systemName: "house")
            })
            
            
            Button(action: {
                
            }, label: {
                Image(systemName: "calendar")
            })
            
            
            Button(action: {
                
            }, label: {
                Image(systemName: "checklist")
            })
            
            
            Button(action: {
                
            }, label: {
                Image(systemName: "person")
            })
        }
        .padding()
        .padding(.vertical)
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(Color.gray.opacity(0.1))
        .accentColor(.primary)
        .font(.system(size: 23))
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

#Preview {
    HomePageView()
}
