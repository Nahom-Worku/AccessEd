//
//  CourseModel.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-11-30.
//

import Foundation
import SwiftUI
import SwiftData


@Model
class CourseModel: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var createdDate: Date = Date()
    
    //TODO: work with the below the save the order of courses
//    var order: Int
    var categoryRawValue: String
    var courseImageName: String
    var courseColorName: String
    
    
    var category: CourseCategory {
        get {
            CourseCategory(rawValue: categoryRawValue) ?? .other
        }
        set {
            categoryRawValue = newValue.rawValue
        }
    }
    
    var courseImage: Image {
        Image(courseImageName)
    }
    
    var courseColor: Color {
        Color(courseColorName)
    }
    
    init(name: String, category: CourseCategory) {
        self.id = UUID()
        self.name = name
        self.categoryRawValue = category.rawValue
        self.courseImageName = category.imageName
        self.courseColorName = category.colorName
    }
    
    func updateCompletion(newName: String, newCategory: CourseCategory) -> CourseModel {
        return CourseModel(
            name: newName,
            category: newCategory
        )
    }
}

// MARK: - UserPreferences Model

@Model
class UserPreferences {
    @Attribute(.unique) var id: UUID
    var inputCourses: [String: Double]
    var excludeList: [String]
    
    init() {
        self.id = UUID()
        self.inputCourses = [:]
        self.excludeList = []
    }
}

enum CourseCategory: String, Codable, CaseIterable {
    case mathematics = "Mathematics"
    case naturalSciences = "Natural Sciences"
    case socialSciences = "Social Sciences"
    case techAndEngineering = "Tech & Engineering"
    case healthAndPE = "Health & PE"
    case artsAndHumanities = "Arts & Humanities"
    case careerAndTech = "Career & Tech"
    case other = "Other"
    
    // The image name directly matches the raw value
    var imageName: String {
        return self.rawValue
    }
    
    // The color name directly matches the raw value
    var colorName: String {
        return self.rawValue
    }
    
    static let map: [String: CourseCategory] = [
        "Language Arts": .artsAndHumanities,
        "History": .artsAndHumanities,
        "Philosophy": .artsAndHumanities,
        "Religious Studies": .artsAndHumanities,
        "Visual and Performing Arts": .artsAndHumanities,
        
        "Geography": .socialSciences,
        "Economics": .socialSciences,
        "Political Science": .socialSciences,
        "Psychology": .socialSciences,
        "Sociology": .socialSciences,
        
        "Biology": .naturalSciences,
        "Chemistry": .naturalSciences,
        "Physics": .naturalSciences,
        "Earth Science": .naturalSciences,
        "Environmental Science": .naturalSciences,
        
        "Arithmetic": .mathematics,
        "Algebra": .mathematics,
        "Geometry": .mathematics,
        "Calculus": .mathematics,
        "Statistics": .mathematics,
        
        "Information Technology": .techAndEngineering,
        "Engineering": .techAndEngineering,
        "Robotics": .techAndEngineering,
        "Computer Science": .techAndEngineering,
        
        "Agricultural Education": .careerAndTech,
        "Business Education": .careerAndTech,
        "Trade Skills": .careerAndTech,
        "Culinary Arts": .careerAndTech,
        
        "Physical Education": .healthAndPE,
        "Health Education": .healthAndPE,
        "Sex Education": .healthAndPE
    ]
    
    // MARK: - might not even need this
    static let coursesByField: [String: [String]] = [
        "Mathematics":       ["Arithmetic", "Algebra", "Geometry", "Calculus", "Statistics"],
        "Natural Sciences":   ["Biology", "Chemistry", "Physics", "Earth Science", "Environmental Science"],
        "Tech & Engineering": ["Information Technology", "Engineering", "Robotics", "Computer Science"],
        "Career & Tech":     ["Aglicultural Education", "Business Education", "Trade Skills", "Culinary Arts"],
        "Social Sciences":     ["Geography", "Economics", "Political Science", "Psychology", "Sociology"],
        "Arts & Humanities": ["Language Arts", "History", "Religious Studies", "Philosophy", "Visual Arts"],
        "Health & PE": ["Physical Education", "Health Education", "Sex Education"]
    ]
    
    static func courses(for category: CourseCategory) -> [String] {
        map
            .filter { $0.value == category }
            .map { $0.key }
    }
}
 

//TODO: update the below accordingly
enum CourseResourses: String, Codable, CaseIterable {
    case textbooks
    case assignments
    case exams
    case notes
    
    var content: [String] {
        switch self {
            case .textbooks:
                return ["Textbooks"]
            case .assignments:
                return ["Assignments"]
            case .exams:
                return ["Exams"]
        case .notes:
            return ["Notes"]
        }
    }
}

enum tabs: String, CaseIterable {
    case Course
    case Resourses
}

enum ResoursesCategory: String, Codable, CaseIterable {
    case textbook = "book.pages"
    case notes = "pencil.and.scribble"
    case assignment = "pencil.and.list.clipboard"
    case exam = "text.document"
}

enum MyAlerts {
    case courseAdded
    case courseDismissed
}
