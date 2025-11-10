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
        
        let timeInterval = max(60, interval * 3600)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
        let identifier = "AbdominalReminderRecurring"
        
        // LIMPEZA TOTAL (resolve duplicatas)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao agendar: \(error)")
            } else {
                print("✅ Notificação agendada: \(reps) reps a cada \(interval)h")
            }
        }
        
        // Recria categoria
        let doAction = UNNotificationAction(identifier: "DO", title: "Fazer agora", options: [.foreground])
        let deferAction = UNNotificationAction(identifier: "DEFER", title: "Adiar 10 min", options: [])
        let category = UNNotificationCategory(identifier: "ABDOMINAL_REMINDER",
                                            actions: [doAction, deferAction],
                                            intentIdentifiers: [],
                                            options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func testNotification(reps: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Teste de Notificação"
        content.body = "Faça \(reps) abdominais (teste)."
        content.sound = .default
        content.categoryIdentifier = "ABDOMINAL_REMINDER"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = "TestAbdominalReminder"
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            error == nil ? print("Notificação de teste OK") : print("Erro teste: \(error!)")
        }
    }
    
    func deferNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Lembrete adiado"
        content.body = "Próximo lembrete em 10 minutos."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 600, repeats: false)
        let identifier = "DeferredAbdominalReminder"
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func clearNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}