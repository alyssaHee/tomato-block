//
//  ContentView.swift
//  Tomato Block
//
//  This file is adapted from Oz Tamir's project Broke, licensed under Apache 2.0
//  Modified by Alyssa Hee on 2025-07-15.
//

import SwiftUI
import CoreNFC
import FamilyControls
import ManagedSettings

struct TomatoView: View {
    // EnvironmentObject shares instance of ObservableObject class throughout views
    @EnvironmentObject private var appBlocker: AppBlocker
    @EnvironmentObject private var profileManager: ProfileManager
    @EnvironmentObject private var timeBlocked: TomatoTimer
    
    // @StateObject is for managing reference types like classes unlike @State which manages simple variables
    @StateObject private var nfcReader = NFCReader()
    private let tagPhrase = "MATO"
    
    // @State is for managing local view-specific state
    @State private var showWrongTagAlert = false
    @State private var showCreateTagAlert = false
    @State private var nfcWriteSuccess = false
    @State private var showSettings = false
    
    private var isBlocking : Bool {
        get {
            return appBlocker.isBlocking
        }
    }
    
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                VStack {
                    if isPad {
                        Spacer()
                            .frame(height: 200.0)
                    } else {
                        Spacer()
                            .frame(height: 120.0)
                    }

                    Text("Protect Your Energy")
                        .font(.kodemono(fontStyle: .title3))
                        .foregroundStyle(.white.opacity(0.65))
                        .padding(.bottom, 4.0)
                    //.textCase(.uppercase)
                    
                    Text(isBlocking ? "Tap to Unblock" : "Tap to Block")
                        .font(.IBMPlexMono())
                        .foregroundColor(Color(red:0.84, green: 0.41, blue:0.41))
                        .padding(.bottom, 4.0)
                    
                    tomatoButton()
                    
                    // display mode in use
                    Text("Mode: \(profileManager.currentProfile.name)")
                    .font(.IBMPlexMono(fontStyle: .body))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 10.0)
                    .padding(.vertical, 3.0)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(6.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6.0)
                            .stroke(.black.opacity(0.75))
                    )
                    
                    if isBlocking {
                        Text("Blocked for \(timeBlocked.formattedElapsedTime)")
                            .font(.IBMPlexMono(fontStyle: .body))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.top, 3.0)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24.0)
                .background(isBlocking ? Color("blockedBg") : Color("unblockedBg"))
                .animation(.spring(), value: isBlocking)
                
                if !isBlocking {
                    Button(action: {
                        withAnimation {
                            showSettings = true
                        }
                    })
                    {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 30)
                            .tint(Color("settingsGear"))
                    }
                    .padding(.top, 30)
                    .padding(.trailing, 30)
                }
                    
                if showSettings {
                    SettingsView(profileManager: profileManager, dismiss: {
                        withAnimation {
                            showSettings = false
                        }
                    })
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .trailing)
                    ))
                    .zIndex(1) // On top
                }
            }
        }
        
    }
    
    
    @ViewBuilder
    private func tomatoButton() -> some View {
        
        // tomato
        Button(action: {
            withAnimation(.spring()) {
                scanTag(method: profileManager.currentProfile.methodSelected)
            }
        }) {
            if isPad {
                Image(isBlocking ? "blockedTomato" : "\(profileManager.currentProfile.icon)1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 120.0)
                    .padding(.bottom, 20.0)
            } else {
                Image(isBlocking ? "blockedTomato" : "\(profileManager.currentProfile.icon)1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 40.0)
                    .padding(.bottom, 20.0)
            }
            
        }
        .transition(.scale)
    }

    
    private func scanTag(method: String) {
        if method == "Manual" {
            NSLog("Toggling manual block")
            appBlocker.toggleBlocking(for: profileManager.currentProfile)
            
            if isBlocking {
                timeBlocked.startTimer()
                // let is for immutable variables
                let currentSessions: Int = profileManager.currentProfile.totalSessions
                profileManager.updateProfile(id: profileManager.currentProfileId!, totalSessions: currentSessions + 1)
            } else {
                timeBlocked.stopTimer()
            }
        } else if method == "NFC" {
            var status: String?
            if isBlocking {
                status = "stop"
            } else {
                status = "start"
            }
            nfcReader.scan(modeName: profileManager.currentProfile.name, status: status!) { payload in
                if payload == tagPhrase {
                    
                    NSLog("Toggling block")
                    appBlocker.toggleBlocking(for: profileManager.currentProfile)
                    
                    if isBlocking {
                        timeBlocked.startTimer()
                        // let is for immutable variables
                        let currentSessions: Int = profileManager.currentProfile.totalSessions
                        profileManager.updateProfile(id: profileManager.currentProfileId!, totalSessions: currentSessions + 1)
                    } else {
                        timeBlocked.stopTimer()
                    }
                    
                } else {
                    showWrongTagAlert = true
                    NSLog("Wrong Tag!\nPayload: \(payload)")
                }
            }
        }
    }
}


#Preview {
    TomatoView()
        .environmentObject(AppBlocker())
        .environmentObject(ProfileManager())
}
