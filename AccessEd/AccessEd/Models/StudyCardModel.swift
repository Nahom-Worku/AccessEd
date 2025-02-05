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
    var question: String
    var answer: String
    var isFlipped: Bool
    
    init(id: UUID = .init(), question: String, answer: String, isFlipped: Bool = false) {
        self.id = id
        self.question = question
        self.answer = answer
        self.isFlipped = isFlipped
    }
}
