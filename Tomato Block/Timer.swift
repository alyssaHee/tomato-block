//
//  Timer.swift
//  Tomato Block
//
//  Created by Alyssa Hee on 2025-08-07.
//

import SwiftUI
import Foundation

class TomatoTimer: ObservableObject {
    private var timerCounting: Bool = false
    private var updateTimer: Foundation.Timer?
    @Published var elapsedTime: TimeInterval = 0
    private var startTime: Date? {
        get { UserDefaults.standard.object(forKey: "startTime") as? Date }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "startTime")
        }
    }
    var isTimerRunning: Bool {
        startTime != nil
    }
    var totalTimeBlocked: TimeInterval = 0
    
    init() {
            if startTime != nil {
                restartTimer()
                NSLog("Restart Timer")
            }
        }
    
    private func timerProc() {
        if let start = self.startTime {
            self.elapsedTime = Date().timeIntervalSince(start)
        }
        }
    
    func restartTimer(){
        self.updateTimer = Foundation.Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedTime = Date().timeIntervalSince(self.startTime!)
                }
                timerProc()
    }
    
    func startTimer() {
        precondition(!isTimerRunning)
        self.startTime = Date()
        self.timerCounting = true
        self.elapsedTime = 0
        restartTimer()
        NSLog("Timer started")
    }

    func stopTimer() {
        precondition(isTimerRunning)
        self.totalTimeBlocked = self.elapsedTime
        self.startTime = nil
        self.updateTimer?.invalidate()
        self.updateTimer = nil
        self.elapsedTime = 0
        NSLog("Timer stopped")
    }


    var formattedElapsedTime: String {
        let totalSeconds = Int(elapsedTime)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    }
}
