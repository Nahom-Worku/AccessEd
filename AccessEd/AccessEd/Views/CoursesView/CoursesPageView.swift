//
//  CoursesPageView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-09.
//

import SwiftUI

struct CoursesPageView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                ForEach(0..<10) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: .infinity, height: 100)
                        .overlay {
                            HStack{
                                Text("my name is na")
                                
                                Spacer()
                                
                                Image(systemName: "chevron.forward")
                                    .foregroundColor(.black)
                            }
                            .padding()
                        }
                }
                
            }
            .navigationTitle("Courses")
            .padding()
        }
//        .padding()
//        .navigationTitle("Courses")
    }
}

#Preview {
    CoursesPageView()
}
