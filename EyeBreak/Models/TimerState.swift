//
//  TimerState.swift
//  EyeBreak
//
//  Created on October 5, 2025.
//

import Foundation

/// Represents the current state of the break timer
enum TimerState: Equatable {
    case idle              // Timer not started
    case working(remainingSeconds: Int)  // Working period
    case preBreak(remainingSeconds: Int) // Warning period before break
    case breaking(remainingSeconds: Int) // Break period
    case paused(wasWorking: Bool, remainingSeconds: Int) // Paused due to idle
    
    var isActive: Bool {
        switch self {
        case .idle, .paused:
            return false
        case .working, .preBreak, .breaking:
            return true
        }
    }
    
    var displayText: String {
        switch self {
        case .idle:
            return L10n.text("Ready to start")
        case .working(let seconds):
            return L10n.format("Next break in %@", formatTime(seconds))
        case .preBreak(let seconds):
            return L10n.format("Break starting in %@s", seconds)
        case .breaking(let seconds):
            return L10n.format("Break time! %@s remaining", seconds)
        case .paused(_, let seconds):
            return L10n.format("Paused - %@ remaining", formatTime(seconds))
        }
    }
    
    private func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

/// Break style options
enum BreakStyle: String, CaseIterable, Identifiable {
    case blurScreen = "Blur Screen"
    case notificationOnly = "Floating Window"
    case eyeExercise = "Eye Exercise"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .blurScreen:
            return L10n.text("Blur your screen during breaks")
        case .notificationOnly:
            return L10n.text("Show a small floating reminder window")
        case .eyeExercise:
            return L10n.text("Guided eye exercise instructions")
        }
    }
    
    var icon: String {
        switch self {
        case .blurScreen:
            return "eye.slash.fill"
        case .notificationOnly:
            return "rectangle.inset.filled.and.person.filled"
        case .eyeExercise:
            return "figure.walk"
        }
    }
}

/// Statistics for tracking break history
struct BreakStats: Codable {
    var date: Date
    var breaksCompleted: Int
    var breaksSkipped: Int
    var totalBreakTime: Int // in seconds
    
    init(date: Date = Date(), breaksCompleted: Int = 0, breaksSkipped: Int = 0, totalBreakTime: Int = 0) {
        self.date = date
        self.breaksCompleted = breaksCompleted
        self.breaksSkipped = breaksSkipped
        self.totalBreakTime = totalBreakTime
    }
}

/// Session type for different work patterns
enum SessionType: String, CaseIterable, Identifiable {
    case standard = "20-20-20"
    case pomodoro = "Pomodoro (25/5)"
    case custom = "Custom"
    
    var id: String { rawValue }
    
    var workMinutes: Int {
        switch self {
        case .standard:
            return 20
        case .pomodoro:
            return 25
        case .custom:
            return 20 // Default, will be overridden by user settings
        }
    }
    
    var breakSeconds: Int {
        switch self {
        case .standard:
            return 20
        case .pomodoro:
            return 300 // 5 minutes
        case .custom:
            return 20 // Default, will be overridden by user settings
        }
    }
}

/// Water reminder style options
enum WaterReminderStyle: String, CaseIterable, Identifiable {
    case blurScreen = "Blur Screen"
    case ambient = "Ambient Pop-up"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .blurScreen:
            return L10n.text("Full screen blur overlay with water reminder")
        case .ambient:
            return L10n.text("Gentle floating reminder window at top of screen")
        }
    }
}
