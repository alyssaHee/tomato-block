//
//  Tomato_BlockApp.swift
//  Tomato Block
//
//  Created by Alyssa Hee on 2025-07-15.
//

import SwiftUI

@main
struct Tomato_BlockApp: App {
    @StateObject private var appBlocker = AppBlocker()
    @StateObject private var profileManager = ProfileManager()
    @StateObject private var tomatoTimer = TomatoTimer()
    
    var body: some Scene {
        WindowGroup {
            TomatoView()
                .environmentObject(appBlocker)
                .environmentObject(profileManager)
                .environmentObject(tomatoTimer)
        }
    }
}
