//
//  ProfileViewModel.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-30.
//

import Foundation
import SwiftData

class ProfileViewModel : ObservableObject {
    private var modelContext: ModelContext? = nil
    @Published var profile: ProfileModel?
    
    
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
            existingProfile.learningStyle = updatedProfile.learningStyle
            existingProfile.studyHours = updatedProfile.studyHours
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
