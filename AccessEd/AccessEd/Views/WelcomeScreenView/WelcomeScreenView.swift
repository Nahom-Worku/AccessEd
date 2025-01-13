//
//  WelcomeScreenView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2025-01-13.
//

import SwiftUI

struct WelcomeScreenView: View {
    @State private var opacity = 0.0
    
    var body: some View {
        VStack {
            // 1. Icon (placeholder)
            Image("App Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .cornerRadius(20)
                .padding(.bottom, 24)
            
            // 2. Main Title
            Text("AccessEd")
                .font(.largeTitle) // Approx Title size
                .bold()
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.5)) {
                        opacity = 1.0
                    }
                }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background (
            LinearGradient(
                gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1))]),
                startPoint: .bottomTrailing,
                endPoint: .topLeading)
        )
    }
}

#Preview {
    WelcomeScreenView()
}
