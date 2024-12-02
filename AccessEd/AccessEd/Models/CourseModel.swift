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

enum CourseCategory: String, CaseIterable {
    case mathematics = "Mathematics"
    case naturalSciences = "Natural Sciences"
    case socialSciences = "Social Sciences"
    case techAndEngineering = "Tech & Engineering"
    case healthAndPE = "Health & PE"
    case languages = "Languages"
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
}
 
