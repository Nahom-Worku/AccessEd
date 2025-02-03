//
//  ProfileViewModel.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-30.
//

import Foundation
import SwiftData
import SwiftUI

class ProfileViewModel : ObservableObject {
    var modelContext: ModelContext? = nil
    
    @Published var profile: ProfileModel?
    @Published var name: String = ""
    @Published var grade: String = "9"
    @Published var preferredLanguage: String = "English"
    @Published var isUserSignedIn: Bool = false
    @Published var onboardingState: Int = 0
    @Published var alertTitle: String = ""
    @Published var showAlert: Bool = false
    
    
    // ***********************
    // for user preference for courses:
    @Published var fieldsOfInterest: [String] = []
    @Published var interestedCourses: [String] = []
    
    var profilePicture: Image {
        if let data = profile?.profilePicture, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.circle") // Default placeholder image
        }
    }
    
    // Add a course to the interested list
    func addCourse(_ course: String) {
        if interestedCourses.count < 3 {
            interestedCourses.append(course)
            profile?.interestedCourses = interestedCourses
            try? modelContext?.save()
            fetchProfile()
        }
        
        /*
         guard let profile = profile else { return }
         if interestedCourses.count < 3 /*&& !interestedCourses.contains(course)*/ {
             interestedCourses.append(course)
             profile.interestedCourses = interestedCourses
             try? modelContext?.save()
             fetchProfile()
         }
         */
    }

    // Remove a course from the interested list
    func removeCourse(_ course: String) {
        interestedCourses.removeAll { $0 == course }
        profile?.interestedCourses = interestedCourses
        try? modelContext?.save()
        fetchProfile()
        
        /*
         guard let profile = profile else { return }
         interestedCourses.removeAll { $0 == course }
         profile.interestedCourses = interestedCourses
         try? modelContext?.save()
         fetchProfile()
         */
    }
    
    func removeAllCourses() {
        profile?.interestedCourses = []
        try? modelContext?.save()
        fetchProfile()
    }
    // *************************
    
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
    
    func updateProfilePicture(with image: UIImage) {
        profile?.profilePicture = image.jpegData(compressionQuality: 0.8)
    }
    
    func addField(_ field: String) {
        fieldsOfInterest.append(field)
        
        guard let profile = profile else { return }
        if !profile.fieldsOfInterest.contains(field) {
            profile.fieldsOfInterest.append(field)
            try? modelContext?.save()
        }
        fetchProfile()
    }
    
    func removeField(_ field: String) {
        fieldsOfInterest.removeAll { $0 == field }
        try? modelContext?.save()
        fetchProfile()
    }
    
    func updateStatus() {
        isUserSignedIn = true
        profile?.isUserSignedIn = isUserSignedIn
        try? modelContext?.save()
        fetchProfile()
    }
    
    func updateNotificationsSettings(isOn: Bool) {
        guard let profile = profile else { return }
        
        profile.isNotificationsOn = isOn
        
        do {
            try modelContext?.save()
            fetchProfile()
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
