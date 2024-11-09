//
//  BottomMenuView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-05.
//

import SwiftUI

struct BottomMenuView: View {
    
    var body: some View {
        HStack(alignment: .center, spacing: 70) {
            
            NavigationLink(destination: HomePageView()) {
                Image(systemName: "house")
            }
                   
            NavigationLink(destination: Text("This is the courses page")) {
                Image(systemName: "books.vertical")
            }
                   
            NavigationLink(destination: CalendarParentView()) {
                Image(systemName: "calendar")
            }
                   
            NavigationLink(destination: ProfileView()) {
                Image(systemName: "person")
            }
            
        }
        .padding()
        .padding(.vertical)
        .frame(maxWidth: .infinity, maxHeight: 60)
        .background(Color.gray.opacity(0.05))
        .accentColor(.primary)
        .font(.system(size: 23))
    }
}

#Preview {
    BottomMenuView()
}

