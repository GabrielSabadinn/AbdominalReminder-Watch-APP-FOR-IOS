//
//  NotificationDelegate.swift
//  AbdominalReminder Watch App
//
//  Created by Gabriel Belleboni Sabadin on 23/10/25.
//

import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    private override init() {}
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "DO" {
            WorkoutData.addReps(WorkoutData.getRepsPerSession())
        } else if response.actionIdentifier == "DEFER" {
            NotificationManager.shared.deferNotification()
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
