import Foundation

struct WorkoutData {
    static let defaults = UserDefaults.standard
    static let reminderIntervalKey = "reminderInterval"
    static let repsPerSessionKey = "repsPerSession"
    static let dailyRepsKey = "dailyReps"
    static let lastResetDateKey = "lastResetDate"
    
    static func saveInterval(_ interval: Double) {
        defaults.set(interval, forKey: reminderIntervalKey)
    }
    
    static func getInterval() -> Double {
        defaults.double(forKey: reminderIntervalKey) > 0 ? defaults.double(forKey: reminderIntervalKey) : 1.0
    }
    
    static func saveRepsPerSession(_ reps: Int) {
        defaults.set(reps, forKey: repsPerSessionKey)
    }
    
    static func getRepsPerSession() -> Int {
        defaults.integer(forKey: repsPerSessionKey) > 0 ? defaults.integer(forKey: repsPerSessionKey) : 10
    }
    
    static func addReps(_ reps: Int) {
        let currentReps = defaults.integer(forKey: dailyRepsKey)
        defaults.set(currentReps + reps, forKey: dailyRepsKey)
        NotificationCenter.default.post(name: .init("WorkoutDataUpdated"), object: nil)
    }
    
    static func getDailyReps() -> Int {
        defaults.integer(forKey: dailyRepsKey)
    }
    
    static func resetDailyReps() {
        defaults.set(0, forKey: dailyRepsKey)
        defaults.set(Date(), forKey: lastResetDateKey)
        NotificationCenter.default.post(name: .init("WorkoutDataUpdated"), object: nil)
    }
    
    static func shouldResetDailyReps() -> Bool {
        guard let lastReset = defaults.object(forKey: lastResetDateKey) as? Date else { return true }
        return !Calendar.current.isDateInToday(lastReset)
    }
}