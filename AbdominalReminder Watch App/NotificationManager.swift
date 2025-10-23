//
//  NotificationManager.swift
//  AbdominalReminder Watch App
//
//  Created by Gabriel Belleboni Sabadin on 23/10/25.
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Erro ao solicitar autorização: \(error)")
            }
        }
    }
    
    func scheduleNotification(interval: Double, reps: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Hora de fazer abdominais!"
        content.body = "Faça \(reps) abdominais agora."
        content.sound = .default
        content.categoryIdentifier = "ABDOMINAL_REMINDER"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval * 3600, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao agendar notificação: \(error)")
            }
        }
        
        let doAction = UNNotificationAction(identifier: "DO", title: "Fazer agora", options: [])
        let deferAction = UNNotificationAction(identifier: "DEFER", title: "Adiar 10 min", options: [])
        let category = UNNotificationCategory(identifier: "ABDOMINAL_REMINDER", actions: [doAction, deferAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func deferNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Lembrete adiado"
        content.body = "Próximo lembrete em 10 minutos."
        content.sound = .default
        content.categoryIdentifier = "ABDOMINAL_REMINDER"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 600, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func clearNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
