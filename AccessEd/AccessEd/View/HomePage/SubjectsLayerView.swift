//
//  SubjectsLayerView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-02.
//

import SwiftUI

struct SubjectsLayerView: View {
    
    @Binding var showAddSubjectSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            
            //*************************
            
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Subjects")
                        .font(.title)
                        .bold()
                    
                    Text("Recommendations for you")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        
                }
//                .padding(.horizontal)
//                .padding(.bottom)
                
                Spacer()
                
                // Add courses button
                Button {
                    showAddSubjectSheet = true
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
            
            
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .center, spacing: 25){
                    
                    //###############################
                    VStack {
                        Image("Geometry")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 120)
                            .clipped()
                            .cornerRadius(10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("Calculus I")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(5)
                        }
                        .padding([.leading, .trailing, .bottom], 8)
                    }
                    .frame(width: 180)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 3)
                    
                    
                    //########################
                    VStack(alignment: .center, spacing: 8) {
                        Image("science")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 120)
                            .clipped()
                            .cornerRadius(10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("Physics I")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(5)
                        }
                        .padding([.leading, .trailing, .bottom], 8)
                    }
                    .frame(width: 180)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 3)
                    
                    //#############################
                    
                    VStack {
                        Image("Business-Finance")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 120)
                            .clipped()
                            .cornerRadius(10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("Business")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(5)
                        }
                        .padding([.leading, .trailing, .bottom], 8)
                    }
                    .frame(width: 180)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 3)
                    
                    //#######################
                    
                    VStack {
                        Image("Tech-Eng")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 120)
                            .clipped()
                            .cornerRadius(10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("Technology")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(5)
                        }
                        .padding([.leading, .trailing, .bottom], 8)
                    }
                    .frame(width: 180)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 3)
                    
                    
                    //#######################
                    
                    VStack {
                        Image("Arts-Humanities2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 120)
                            .clipped()
                            .cornerRadius(10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("Art")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(5)
                        }
                        .padding([.leading, .trailing, .bottom], 8)
                    }
                    .frame(width: 180)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 3)
                    
                    //############################
                    VStack {
                        Image("Social Sciences")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 120)
                            .clipped()
                            .cornerRadius(10)
                        
                        VStack(alignment: .center, spacing: 4) {
                            Text("Geography")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(5)
                        }
                        .padding([.leading, .trailing, .bottom], 8)
                    }
                    .frame(width: 180)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 3)
                    
                    
                }
                .frame(height: 200)
            }
            .frame(maxWidth: .infinity, maxHeight: 250)
            .padding(.trailing, 15)
            
        }
        .padding()
    }
}

#Preview {
    SubjectsLayerView(showAddSubjectSheet: .constant(true))
}
