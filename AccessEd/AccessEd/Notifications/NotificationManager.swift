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

    // Handle notifications when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Display as a banner and play a sound
        completionHandler([.banner, .sound])
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
    
    func scheduleNotification(at date: Date, title: String, body: String, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        // Extract date components
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false) // Change to false to trigger once

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully for \(date)")
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
