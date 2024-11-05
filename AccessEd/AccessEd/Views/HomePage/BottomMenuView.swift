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
                   
            NavigationLink(destination: NoItemsView()) {
                Image(systemName: "calendar")
            }
                   
            NavigationLink(destination: ListView()) {
                Image(systemName: "checklist")
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
