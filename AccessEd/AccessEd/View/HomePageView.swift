//
//  HomePageView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-10-25.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
                    
                    // Top green globe and search bar area
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.green.opacity(0.9)) // Placeholder for the top background
                            .frame(height: 220)
                        
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass") // Search Icon placeholder
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                        
                        // Placeholder for the globe illustration
                        VStack {
                            Spacer()
                            Circle()
                                .fill(Color.green)
                                .frame(width: 120, height: 120)
                                .offset(x: -40)
                            
                            Spacer()
                        }
                    }
                    
                    // Subjects section
                    Text("Subjects")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Text("Recommendations for you")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    HStack {
                        // Mathematics
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.orange)
                            .frame(width: 160, height: 100)
                            .overlay(
                                VStack {
                                    Text("Mathematics")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding()
                            )
                        
                        Spacer()
                        
                        // Geography
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue)
                            .frame(width: 160, height: 100)
                            .overlay(
                                VStack {
                                    Text("Geography")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding()
                            )
                    }
                    .padding(.horizontal)
                    
                    // Your Schedule Section
                    Text("Your Schedule")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Text("Next lessons")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    // Biology Schedule card
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.green)
                        .frame(height: 100)
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
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    // Bottom Tab bar placeholders
                    HStack {
                        Spacer()
                        Image(systemName: "house.fill")
                            .font(.title)
                        Spacer()
                        Image(systemName: "calendar")
                            .font(.title)
                        Spacer()
                        Image(systemName: "message")
                            .font(.title)
                        Spacer()
                        Image(systemName: "person.crop.circle")
                            .font(.title)
                        Spacer()
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                }
                .edgesIgnoringSafeArea(.all)
                .background(Color(.systemGray6))
            }
    }
    
    
    var bottomMenu: some View {
        HStack(spacing: 60) {
            Button(action: {
                
            }, label: {
                Image(systemName: "house")
            })
            
            
            Button(action: {
                
            }, label: {
                Image(systemName: "star")
            })
            
            
            Button(action: {
                
            }, label: {
                Image(systemName: "calendar")
            })
            
            
            Button(action: {
                
            }, label: {
                Image(systemName: "person")
            })
        }
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(Color.white)
//        .foregroundStyle(.secondary)  // add color in the asset folder
        .font(.system(size: 25))
}

#Preview {
    HomePageView()
}


/*
 ZStack {
     Color.green.ignoresSafeArea(edges: .top)
     
     VStack(alignment: .leading) {
         Image(systemName: "bell")
             .resizable()
             .foregroundColor(Color.black)
             .frame(width: 50, height: 50)
             .scaledToFit()
             .shadow(color: Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)), radius: 50, x: 0.0, y: 10)
             .overlay(
                 Circle()
                     .fill(Color.red)
                     .frame(width: 25, height: 25)
                     .overlay(
                         Text("5")
                             .foregroundColor(Color.white)
                             .bold()
                     )
                 ,alignment: .topTrailing
             )
     }
     .frame(width: 50, height: 50)
     .padding()
     .background(Color.white)
     
     Spacer()
     
     
     ScrollView {
         Text("Subject")
         
         ScrollView (.horizontal, showsIndicators: false) {
             HStack {
                 RoundedRectangle(cornerRadius: 25)
                     .frame(width: 175, height: 150)
                 
                 RoundedRectangle(cornerRadius: 25)
                     .frame(width: 175, height: 150)
             }
             .padding()
         }
     }
     .padding()
     .frame(maxWidth: .infinity, maxHeight: 500)
     .background(Color.white).cornerRadius(25)
//
     
     
     // bottom menu
     VStack {
         Spacer()
         
         bottomMenu
     }
 }
 */
