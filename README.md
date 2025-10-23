# AbdominalReminder Watch App

AbdominalReminder is a minimalist and intuitive watchOS application designed for the Apple Watch Ultra 2 (watchOS 11). It helps users stay consistent with their abdominal exercises by sending periodic reminders and tracking daily repetitions. The app features a clean, modern interface optimized for the small screen of the Apple Watch, with customizable reminder intervals and repetition counts.

## Features

- **Periodic Reminders**: Schedule notifications to remind you to do abdominal exercises at customizable intervals (1, 2, 3, 4, or 6 hours).

- **Repetition Tracking**: Log the number of repetitions completed each day, with options ranging from 10 to 200 reps per session.

- **Reset Daily Count**: Easily reset the daily repetition counter with a dedicated button.

- **Interactive Notifications**: Respond to reminders with "Do Now" to log reps or "Defer" to delay the reminder by 10 minutes.

- **Minimalist Design**: A sleek, intuitive interface with small fonts, subtle colors (cyan, white, gray, blue), and compact elements tailored for the Apple Watch.

- **Customizable Settings**: Configure reminder intervals and reps per session through an optimized settings screen.

## Project Structure

- **AbdominalReminderApp.swift**: Main app entry point, sets up the watchOS app and notification delegate.

- **ContentView.swift**: Contains the main UI (counter, buttons) and settings screen (pickers for intervals and reps).

- **WorkoutData.swift**: Manages persistent data (reps, intervals, reset date) using UserDefaults.

- **NotificationManager.swift**: Handles notification scheduling and actions.

- **NotificationDelegate.swift**: Processes notification responses (e.g., logging reps or deferring).
