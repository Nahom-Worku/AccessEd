//
//  HomePageView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-10-25.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        
        ScrollView(.vertical) {
            
            VStack {
                
                ZStack {
                    
                    HStack {
                        Text("AccessEd")
                            .font(.largeTitle)
                        
                        Spacer()
                        
                        Image("education")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 130, height: 150)
                            .clipped()
                    }
                    .padding()
                    .padding(.top, 50)
                    .frame(maxWidth: 350, maxHeight: 150)

                }
                .frame(height: 250)
                
                
                
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
        
        
        // Bottom Tab bar placeholders
        bottomMenu
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
                    
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "plus")
                        
                        Text("Add")
                    }
                }
            }
            .padding(.top, 15)
            .padding(.trailing, 15)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    // Mathematics
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.orange)
                        .frame(width: 150, height: 120)
                        .overlay(
                            VStack {
                                HStack {
                                    Image(systemName: "x.squareroot")
                                    
                                    Spacer()
                                    
                                    Image(systemName: "ellipsis.circle")
                                    
                                }
                                .foregroundStyle(Color.white)
                                .font(Font.system(size: 20))
                                
                                
                                Spacer()
                                
                                Text("Mathematics")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .padding()
                        )
                    
                    
                    // Chemistry
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue)
                        .frame(width: 150, height: 120)
                        .overlay(
                            VStack {
                                HStack {
                                    Image(systemName: "atom")
                                    
                                    Spacer()
                                    
                                    Image(systemName: "ellipsis.circle")
                                    
                                }
                                .foregroundStyle(Color.white)
                                .font(Font.system(size: 20))
                                
                                
                                Spacer()
                                
                                Text("Chemistry")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .padding()
                        )
                    
                    // Geography
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)), Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1))]),
                                startPoint: .leading,
                                endPoint: .trailing)
                        )
                        .frame(width: 150, height: 120)
                        .overlay(
                            VStack {
                                HStack {
                                    Image(systemName: "globe.europe.africa.fill")
                                    
                                    Spacer()
                                    
                                    Image(systemName: "ellipsis.circle")
                                    
                                }
                                .foregroundStyle(Color.white)
                                .font(Font.system(size: 20))
                                
                                
                                Spacer()
                                
                                Text("Geography")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .padding()
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
                        gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)), Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1))]),
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

#Preview {
    HomePageView()
}
