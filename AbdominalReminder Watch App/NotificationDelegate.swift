import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    private override init() {}
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("🔔 Ação recebida: \(response.actionIdentifier)")
        
        if response.actionIdentifier == "DO" {
            let reps = WorkoutData.getRepsPerSession()
            print("💪 Adicionando \(reps) reps")
            WorkoutData.addReps(reps)
        } else if response.actionIdentifier == "DEFER" {
            NotificationManager.shared.deferNotification()
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}