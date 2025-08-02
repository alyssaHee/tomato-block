//
//  Tomato_BrickApp.swift
//  Tomato Brick
//
//  Created by Alyssa H on 2025-07-15.
//

import SwiftUI

@main
struct Tomato_BrickApp: App {
    @StateObject private var appBlocker = AppBlocker()
    @StateObject private var profileManager = ProfileManager()
    
    var body: some Scene {
        WindowGroup {
            TomatoView()
                .environmentObject(appBlocker)
                .environmentObject(profileManager)
        }
    }
}
