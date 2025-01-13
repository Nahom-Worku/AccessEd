//
//  AppIntroView.swift
//  AccessEd
//
//  Created by Nahom Worku on 2025-01-02.
//

import SwiftUI

struct AppIntroView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var viewModel = ProfileViewModel()
    @State var navigateToHome: Bool = false
    
    var body: some View {
        ZStack {
            if viewModel.profile?.isUserSignedIn == true {
                if navigateToHome {
                    AccessEdTabView()
                        .transition(.opacity)
                } else {
                    WelcomeScreenView()
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    navigateToHome = true
                                }
                            }
                        }
                }
            } else {
                OnboardingView()
            }
        }
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.fetchProfile()
        }
        .animation(.easeInOut, value: navigateToHome)
    }
}

#Preview {
    AppIntroView()
}
