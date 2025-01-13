//
//  NotificationManager.swift
//  AccessEd
//
//  Created by Nahom Worku on 2025-01-11.
//

import SwiftUI
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    func configure() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
    
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

    func notifyProfileSetup(userName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Profile Setup Complete 🎉"
        content.body = "Hi \(userName), welcome to AccessEd! Explore your courses now."
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

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    // Handle notifications while app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Display notification as a banner and play sound
        completionHandler([.banner, .sound])
    }

    // Handle user interaction with notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Perform action when user interacts with notification
        print("Notification tapped: \(response.notification.request.identifier)")
        completionHandler()
    }
}
