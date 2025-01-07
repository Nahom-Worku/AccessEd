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
    @Published var fieldsOfInterest: [String] = []
    @Published var isUserSignedIn: Bool = false
    @Published var onboardingState: Int = 0
    @Published var alertTitle: String = ""
    @Published var showAlert: Bool = false
    
    
    init() {
        fetchProfile()
    }
    
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
                try? modelContext?.save()
                
                fetchProfile()
            }
        } catch {
            print("Failed to fetch or set up profile: \(error.localizedDescription)")
        }
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
    
    func addField(_ field: String) {
        fieldsOfInterest.append(field)
        try? modelContext?.save()
        fetchProfile()
    }
    
    func removeField(_ field: String) {
        fieldsOfInterest.removeAll { $0 == field }
        try? modelContext?.save()
        fetchProfile()
    }
    
    func updateStatus() {
        isUserSignedIn = true
        try? modelContext?.save()
        fetchProfile()
    }
    
    func updateNotificationsSettings(isOn: Bool) {
        guard let profile = profile else { return }
        
        profile.isNotificationsOn = isOn
        
        do {
            try modelContext?.save()
        } catch {
            print("Error saving notification settings: \(error.localizedDescription)")
        }
    }
    
    func deleteProfile() {
        guard let context = modelContext else {
            print("ModelContext is not set.")
            return
        }

        // Ensure there's a profile to delete
        guard let profileToDelete = profile else {
            print("No profile to delete.")
            return
        }

        do {
            // Remove the profile from the context
            context.delete(profileToDelete)

            // Save the context to persist the deletion
            try context.save()

            // Clear the in-memory reference
            self.profile = nil

            print("Profile successfully deleted.")
        } catch {
            print("Failed to delete profile: \(error.localizedDescription)")
        }
    }
}
