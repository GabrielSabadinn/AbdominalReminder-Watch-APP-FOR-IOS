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
  
    }
}
