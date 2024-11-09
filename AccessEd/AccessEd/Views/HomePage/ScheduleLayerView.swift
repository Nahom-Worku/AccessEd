//
//  ScheduleLayerView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-08.
//

import SwiftUI

struct ScheduleLayerView: View {
    var body: some View {
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
                .frame(width: .infinity, height: 120)
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
                .frame(width: .infinity, height: 120)
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
                .frame(width: 350,height: 120)
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
    }
}

#Preview {
    ScheduleLayerView()
}
