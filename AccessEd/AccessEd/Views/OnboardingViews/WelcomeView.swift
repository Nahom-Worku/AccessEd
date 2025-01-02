//
//  WelcomeView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-30.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 20) {
                    
            Spacer().frame(height: 40) // Top padding
                    
                    // 1. Icon (placeholder)
                    Image("App Icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .cornerRadius(20)
                        .padding(.bottom, 24)
                    
                    // 2. Main Title
                    Text("Welcome to AccessEd")
                        .font(.system(size: 28, weight: .bold)) // Approx Title size
                        .foregroundStyle(Color("Text-Colors"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                    
                    // 3. Subtitle / Body Text
                    Text("Discover learning resources and programs that support the UN Sustainable Development Goals—empowering learners to make a global impact.")
                        .font(.system(size: 15))
                        .foregroundStyle(Color("Text-Colors"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 50)
                    

                    
                    // 5. Small icon or illustration for data usage
                    Image(systemName: "person.2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                        .padding(.bottom, 8)
                    
                    // 6. Data usage paragraph
                    Text("AccessEd collects limited, anonymized data to personalize content and measure educational impact. Your engagement supports progress toward the SDGs.")
                        .font(.system(size: 12))  // Slightly smaller than body
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    
                    // 7. “Get Started” Button
//                    Button(action: {
//                        // Handle "Get Started" action
//                    }) {
//                        Text("Get Started")
//                            .font(.system(size: 17, weight: .bold))
//                            .frame(maxWidth: .infinity, minHeight: 50)
//                        // TODO: - add button colors for this to match the Books App
//                            .foregroundColor(Color("Light-Dark Mode Colors"))
//                            .background(Color("Text-Colors"))
//                            .cornerRadius(10)
//                            .padding(.horizontal, 24)
//                    }
                    
                    Spacer().frame(height: 40) // Bottom spacing
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
    }
}

#Preview("Light Mode") {
    WelcomeView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    WelcomeView()
        .preferredColorScheme(.dark)
}
