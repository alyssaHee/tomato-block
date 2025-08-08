//
//  Timer.swift
//  Tomato Brick
//
//  Created by Alyssa H on 2025-08-07.
//

import SwiftUI
import Foundation

class TomatoTimer: ObservableObject {
    private var startTime: Date?
    private var updateTimer: Foundation.Timer?

    func startTimer() {
        self.startTime = Date()
        self.updateTimer = Foundation.Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.objectWillChange.send()
        }
    }

    func stopTimer() {
        self.startTime = nil
        self.updateTimer?.invalidate()
        self.updateTimer = nil
    }

    func timeBlocked() -> TimeInterval {
        return -(self.startTime?.timeIntervalSinceNow ?? 0)
    }

    var formattedElapsedTime: String {
        let totalSeconds = Int(timeBlocked())
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        return "\(hours) : \(minutes)"
    }
}
