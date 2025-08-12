//
//  AppBlocker.swift
//  Tomato Brick
//
//  Created by Alyssa H on 2025-08-01.
//

import SwiftUI
import ManagedSettings
import FamilyControls
import ManagedSettingsUI

class AppBlocker: ObservableObject {
    let store = ManagedSettingsStore()
    
    // @Published is for managing shared state and communication between views
    // It is public by default
    @Published var isBlocking = false
    @Published var isAuthorized = false
    
    // init is a method (initializer) to create and set up an instance of a class, struct or enum
    init() {
        loadBlockingState()
        
        // Task is used to run a segment async/in background
        Task {
            await requestAuthorization()
        }
    }
    
    private func loadBlockingState() {
        isBlocking = UserDefaults.standard.bool(forKey: "isBlocking")
    }
    
    private func saveBlockingState() {
        UserDefaults.standard.set(isBlocking, forKey: "isBlocking")
    }
    
    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            DispatchQueue.main.async {
                self.isAuthorized = true
            }
            
        } catch {
            print("Failed to request authorization: \(error)")
            DispatchQueue.main.async {
                self.isAuthorized = false
            }
        }
    }
    
    
    func toggleBlocking(for profile: Profile) {
        guard isAuthorized else {
            print("Tomato Brick isn't authorized to block apps")
            return
        }
        
        isBlocking.toggle()
        saveBlockingState()
        applyBlockingSettings(for: profile)
    }
    
    
    func applyBlockingSettings(for profile: Profile) {
        
        
        if isBlocking {
            NSLog("Blocking \(profile.appTokens.count) apps")
            store.shield.applications = profile.appTokens.isEmpty ? nil : profile.appTokens
            store.shield.applicationCategories = profile.categoryTokens.isEmpty ? ShieldSettings.ActivityCategoryPolicy.none : .specific(profile.categoryTokens)
        } else {
            store.shield.applications = nil
            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.none
        }
    }
    
    
    
    
    
    
}
