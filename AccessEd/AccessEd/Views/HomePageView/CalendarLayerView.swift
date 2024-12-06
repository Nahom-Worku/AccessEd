//
//  CalendarLayerView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-05.
//

import SwiftUI

struct CalendarLayerView: View {
    var body: some View {
        VStack(alignment: .leading){
            // Your Schedule Section
            
            
            Text("Your ToDo List")
                .font(.title)
                .bold()
            
            Text("Tasks to complete")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 30)
            
            
            HStack(alignment: .center) {
                Spacer()
                
                // TODO: get tasks data and update code accordingly 
                
                Text("No tasks!")
                    .font(.subheadline)
                    
                Spacer()
            }
        }
        .padding()
        .frame(width: 400, alignment: .leading)
        
    }
}

#Preview {
    CalendarLayerView()
}
