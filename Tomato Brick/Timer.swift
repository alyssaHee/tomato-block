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

    @Published var elapsedTime: TimeInterval = 0
    
    func startTimer() {
        self.startTime = Date()
        self.updateTimer = Foundation.Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                    self.elapsedTime = self.timeBlocked()
                }
        NSLog("Timer started")
    }

    func stopTimer() {
        self.startTime = nil
        self.updateTimer?.invalidate()
        self.updateTimer = nil
        NSLog("Timer stopped")
    }

    func timeBlocked() -> TimeInterval {
        return -(self.startTime?.timeIntervalSinceNow ?? 0)
    }

    var formattedElapsedTime: String {
        let totalSeconds = Int(timeBlocked())
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = (totalSeconds - hours*3600 - minutes*60)
        if seconds < 10 && minutes < 10 {
            return "\(hours):0\(minutes):0\(seconds)"
        } else if seconds < 10 {
            return "\(hours):\(minutes):0\(seconds)"
        } else if minutes < 10 {
            return "\(hours):0\(minutes):\(seconds)"
        } else {
            return "\(hours):\(minutes):\(seconds)"
        }
        
    }
}
