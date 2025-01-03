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
    
    var body: some View {
        ZStack {
            if ((viewModel.profile?.userSignedIn) != nil) {
                AccessEdTabView()
            } else {
                OnboardingView()
            }
        }
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.fetchProfile()
            
            print(viewModel.isUserSignedIn)
        }
    }
}

#Preview {
    AppIntroView()
}
