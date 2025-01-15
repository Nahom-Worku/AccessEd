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
            if viewModel.profile?.isUserSignedIn == true &&  viewModel.profile?.isUserSignedIn != nil {
                if navigateToHome {
                    AccessEdTabView()
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                } else {
                    LoadingScreenView()
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
        .animation(.easeInOut, value: navigateToHome)
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.fetchProfile()
        }
        
    }
}


#Preview {
    AppIntroView()
}
