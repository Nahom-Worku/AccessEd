//
//  CalendarModel.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-06.
//

import Foundation
import SwiftUI
import SwiftData


@available(iOS 17, *)
@Model
class CalendarModel: Identifiable {
    @Attribute(.unique) var date: Date
    var color: String
    
    init(date: Date, color: String) {
        self.date = date
        self.color = color
    }
}

@available(iOS 17, *)
@Model
class Task: Identifiable {
    @Attribute(.unique) var id: UUID
    var date: Date
    var name: String
    var completed: Bool
    
    init(id: UUID = .init(), date: Date, name: String, completed: Bool = false) {
        self.id = id
        self.date = date
        self.name = name
        self.completed = completed
    }
}
