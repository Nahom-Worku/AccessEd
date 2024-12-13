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
                .padding(.bottom, 30)
            
            
            HStack() {
                Spacer()
                
                Text("No lessons scheduled!")
                    .font(.subheadline)
                    
                Spacer()
            }
            .frame(minHeight: 50)
            
            Spacer()
        }
        .padding()
        .frame(width: 400, alignment: .leading)
        
    }
}

#Preview {
    ScheduleLayerView()
}
