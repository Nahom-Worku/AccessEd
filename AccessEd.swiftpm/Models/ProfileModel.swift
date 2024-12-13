//
//  ProfileModel.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-08.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
class ProfileModel: Identifiable {
    var id: UUID = UUID()
    var name: String
    var grade: String
    var preferredLanguage: String
    var fieldsOfInterest: [String]
  
    init(name: String, grade: String, preferredLanguage: String, fieldsOfInterest: [String]) {
        self.name = name
        self.grade = grade
        self.preferredLanguage = preferredLanguage
        self.fieldsOfInterest = fieldsOfInterest
    }
}

enum Language: String, CaseIterable {
    case english = "English"
    case spanish = "Spanish"
    case french = "French"
    case mandarin = "Mandarin"
    case arabic = "Arabic"
    
    // Optional: Add a computed property or method if needed
    static var allLanguages: [String] {
        return Language.allCases.map { $0.rawValue }
    }
}

enum FieldOfStudy: String, CaseIterable {
    case artsAndHumanities = "Arts & Humanities"
    case socialSciences = "Social Sciences"
    case naturalSciences = "Natural Sciences"
    case mathematics = "Mathematics"
    case techAndEngineering = "Tech & Engineering"
    case healthAndPE = "Health & PE"
    case careerAndTech = "Career & Tech"
    
    // Optional: Add a computed property or method if needed
    static var allFields: [String] {
        return FieldOfStudy.allCases.map { $0.rawValue }
    }
}
