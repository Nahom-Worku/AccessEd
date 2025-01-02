//
//  ProfileModel.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-08.
//

import Foundation
import SwiftData

@Model
class ProfileModel: Identifiable {
    var id: UUID = UUID()
    var name: String
    var grade: String
    var preferredLanguage: String
    var fieldsOfInterest: Set<FieldsOfStudy>
    var timeZone: String // e.g., "America/New_York"
    var userSignedIn: Bool = false
  
    // TODO: - get rid of learningStyle, studyHours and set timeZone = TimeZone.current.identifier
    
    init(name: String, grade: String, preferredLanguage: String, fieldsOfInterest: Set<FieldsOfStudy>, timeZone: String = TimeZone.current.identifier) {
        self.name = name
        self.grade = grade
        self.preferredLanguage = preferredLanguage
        self.fieldsOfInterest = fieldsOfInterest
        self.timeZone = timeZone
    }
}


// MARK: - enums
enum Languages: String, CaseIterable {
    case arabic = "Arabic"
    case chineseSimplified = "Chinese (Mandarin – simplified)"
    case english = "English"
    case french = "French"
    case german = "German"
    case italian = "Italian"
    case japanese = "Japanese"
    case korean = "Korean"
    case portugueseBrazil = "Portuguese (Brazil)"
    case russian = "Russian"
    case spanish = "Spanish"
    
    // Optional: Add a computed property or method if needed
    static var allLanguages: [String] {
        return Languages.allCases.map { $0.rawValue }
    }
}

enum FieldsOfStudy: String, Codable, CaseIterable {
    case artsAndHumanities = "Arts & Humanities"
    case socialSciences = "Social Sciences"
    case naturalSciences = "Natural Sciences"
    case mathematics = "Mathematics"
    case techAndEngineering = "Tech & Engineering"
    case healthAndPE = "Health & PE"
    case careerAndTech = "Career & Tech"
    
    // Optional: Add a computed property or method if needed
    static var allFields: [String] {
        return FieldsOfStudy.allCases.map { $0.rawValue }
    }
}
