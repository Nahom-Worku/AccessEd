//
//  LoadingScreenView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2025-01-13.
//

import SwiftUI

struct LoadingScreenView: View {
    @State private var animateGradient = false
        
    var body: some View {
        ZStack {            
            LinearGradient(
                gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))]),
                startPoint: animateGradient ? .top : .topTrailing,
                endPoint: animateGradient ? .bottomTrailing : .bottom
            )
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                // Animate the gradient
                withAnimation(
                    Animation.linear(duration: 5).repeatForever(autoreverses: true)
                ) {
                    animateGradient.toggle()
                }
            }
            
            VStack {
                // Logo with Shadow
                Image("App Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .padding(.bottom, 20)
                
                // App Name and Tagline
                VStack(spacing: 5) {
                    Text("AccessEd")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                    
                    Text("Your Gateway to Knowledge")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.bottom, 40)
                
                // Progress Indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
    }
}

#Preview {
    LoadingScreenView()
}
