//
//  ProfileViewModel.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-30.
//

import Foundation
import SwiftData

class ProfileViewModel : ObservableObject {
    var modelContext: ModelContext? = nil
    @Published var profile: ProfileModel?
    
    @Published var name: String = ""
    @Published var grade: String = "9"
    @Published var preferredLanguage: String = "English"
    @Published var selectedFieldsOfStudy: Set<FieldsOfStudy> = []
    
    @Published var onboardingState: Int = 0
    
    @Published var alertTitle: String = ""
    @Published var showAlert: Bool = false
    
    
    func fetchProfile() {
        guard let context = modelContext else {
            print("ModelContext is not set.")
            return
        }

        do {
            // Fetch the profile from the database
            if let fetchedProfile = try context.fetch(FetchDescriptor<ProfileModel>()).first {
                self.profile = fetchedProfile
            } else {
                print("No profile found.")
            }
        } catch {
            print("Failed to fetch profile: \(error.localizedDescription)")
        }
    }
    
    func setUpProfile(profile: ProfileModel) {
        guard let context = modelContext else {
            print("ModelContext is not set.")
            return
        }
        
        do {
            // Check if a profile already exists
            if let existingProfile = try context.fetch(FetchDescriptor<ProfileModel>()).first {
                self.profile = existingProfile
            } else {
                context.insert(profile)
                self.profile = profile
            }
        } catch {
            print("Failed to fetch or set up profile: \(error.localizedDescription)")
        }
    }
    
    func getProfile() -> ProfileModel? {
        return profile
    }
    
    func updateProfile(updatedProfile: ProfileModel) {
        guard let context = modelContext else {
            print("ModelContext is not set.")
            return
        }

        // Fetch the current profile from the database
        if let existingProfile = try? context.fetch(FetchDescriptor<ProfileModel>()).first {
            // Update fields
            existingProfile.name = updatedProfile.name
            existingProfile.grade = updatedProfile.grade
            existingProfile.preferredLanguage = updatedProfile.preferredLanguage
            existingProfile.fieldsOfInterest = updatedProfile.fieldsOfInterest
            existingProfile.timeZone = updatedProfile.timeZone

            // Save changes to the database
            do {
                try context.save()
                self.profile = existingProfile // Update the published property
            } catch {
                print("Failed to save profile: \(error.localizedDescription)")
            }
        }
    }
}
