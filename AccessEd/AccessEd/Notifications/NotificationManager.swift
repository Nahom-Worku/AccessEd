//
//  NotificationManager.swift
//  AccessEd
//
//  Created by Nahom Worku on 2025-01-11.
//

import SwiftUI
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Authorization error: \(error)")
            } else if granted {
                print("Notification authorization granted!")
            } else {
                print("Notification authorization denied.")
            }
        }
    }

    func notifyProfileSetup() {
        let content = UNMutableNotificationContent()
        content.title = "Profile Setup Complete"
        content.body = "Welcome to the app! Start exploring your tasks and other features."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling profile setup notification: \(error)")
            }
        }
    }

    func scheduleDailyUncompletedTasksNotification(for tasks: [TaskModel]) {
        let uncompletedTasks = tasks.filter { !$0.isCompleted }
        guard !uncompletedTasks.isEmpty else { return }

        let content = UNMutableNotificationContent()
        content.title = "You have uncompleted tasks"
        content.body = "You still have \(uncompletedTasks.count) tasks to complete today. Don't forget to finish them!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 20 // 8 PM
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyUncompletedTasks", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily tasks notification: \(error)")
            }
        }
    }
}

