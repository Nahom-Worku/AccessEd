//
//  SubjectsLayerView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-02.
//

import SwiftUI

struct CoursesLayerView: View {
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Courses")
                        .font(.title)
                        .bold()
                    
                    Text("Recommendations for you")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        
                }
//                .padding(.horizontal)
//                .padding(.bottom)
                
                Spacer()
            }
            .padding(.top, 15)
            .padding(.trailing, 15)
            
            ScrollView(.horizontal ,showsIndicators: true) {
                HStack(alignment: .center, spacing: 20){
                    ForEach(CourseCategory.allCases, id: \.self) { category in
                        
                        VStack {
                            Image(category.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 100) // 120
                                .clipped()
                                .cornerRadius(10)
                            
                            VStack(alignment: .center, spacing: 4) {
                                Text(category.rawValue)
                                    .font(.footnote)
                                    .foregroundColor(.primary)
                                    .padding(5)
                            }
                            .padding([.leading, .trailing, .bottom], 8)
                        }
                        .frame(width: 150) // 180
                        .background(Color("Courses-Colors"))
                        .cornerRadius(15)
                        .shadow(radius: 3)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
            }
                
            
        }
        .padding()
    }
}


#Preview("Light Mode") {
    CoursesLayerView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    CoursesLayerView()
        .preferredColorScheme(.dark)
}
