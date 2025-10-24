import SwiftUI
import UserNotifications

@main
struct AbdominalReminder_Watch_AppApp: App {
    @WKApplicationDelegateAdaptor(AbdominalReminderAppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AbdominalReminderAppDelegate: NSObject, WKApplicationDelegate {
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        NotificationManager.shared.requestAuthorization()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let interval = WorkoutData.getInterval()
            let reps = WorkoutData.getRepsPerSession()
            NotificationManager.shared.clearNotifications()
            NotificationManager.shared.scheduleNotification(interval: interval, reps: reps)
        }
    }
}
