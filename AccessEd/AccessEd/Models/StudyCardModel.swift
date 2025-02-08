//
//  StudyCardModel.swift
//  AccessEd
//
//  Created by Nahom Worku on 2025-02-04.
//

import Foundation
import SwiftData

@Model
class StudyCardModel: Identifiable {
    @Attribute(.unique) var id: UUID
    var studyCardName: String?
    var question: String
    var answer: String
    var isFlipped: Bool
    var course: CourseModel?
    
    
    init(id: UUID = .init(), studyCardName: String? = nil, question: String, answer: String, isFlipped: Bool = false, course: CourseModel? = nil) {
        self.id = id
        self.studyCardName = studyCardName
        self.question = question
        self.answer = answer
        self.isFlipped = isFlipped
        self.course = course
    }
}
