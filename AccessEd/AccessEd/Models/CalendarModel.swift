//
//  CalendarModel.swift
//  AccessEd
//
//  Created by Nahom Worku on 2024-12-06.
//

import Foundation
import SwiftUI
import SwiftData


@Model
class CalendarModel: Identifiable {
    @Attribute(.unique) var date: Date
    var color: String
    
    init(date: Date, color: String) {
        self.date = date
        self.color = color
    }
}

@Model
class TaskModel: Identifiable {
    @Attribute(.unique) var id: UUID
    var date: Date
    var name: String
    var isCompleted: Bool
    
    init(id: UUID = .init(), date: Date, name: String, isCompleted: Bool = false) {
        self.id = id
        self.date = date
        self.name = name
        self.isCompleted = isCompleted
    }
}

enum TaskAlerts: Identifiable {
    case removeAllTasks
    case deleteTask

    var id: String {
        switch self {
        case .removeAllTasks:
            return "removeAllTasks"
        case .deleteTask:
            return "deleteTask"
        }
    }
}
