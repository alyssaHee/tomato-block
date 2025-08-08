//
//  ContentView.swift
//  Tomato Brick
//
//  Created by Alyssa H on 2025-07-15.
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
    
    var body: some View {
        
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                VStack {
                    Spacer()
                        .frame(height: 120.0)
                    
                    Text("Protect Your Energy")
                        .font(.kodemono(fontStyle: .title2))
                        .foregroundStyle(.white)
                        .padding(.bottom, 4.0)
                    //.textCase(.uppercase)
                    
                    Text(isBlocking ? "Tap to Unblock" : "Tap to Block")
                        .font(.IBMPlexMono())
                        .foregroundColor(Color(red:0.84, green: 0.41, blue:0.41))
                        .padding(.bottom, 4.0)
                    
                    tomatoButton()
                    
                    // display mode in use
                    Text("Mode: \(profileManager.currentProfile.name)")
                    .font(.IBMPlexMono(fontStyle: .headline))
                    .foregroundStyle(.black)
                    .padding(.horizontal, 10.0)
                    .padding(.vertical, 3.0)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(6.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6.0)
                            .stroke(.black.opacity(0.75))
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 0)
                    )
                    
                    if isBlocking {
                        Text("Blocked for \(timeBlocked.formattedElapsedTime)")
                            .font(.IBMPlexMono(fontStyle: .headline))
                            .foregroundColor(.white)
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
                            .tint(Color(red: 0.67, green: 0.59, blue: 0.59))
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
                    .transition(.identity)
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
                scanTag()
            }
        }) {
            Image(isBlocking ? "blockTomato" : "defaultTomato")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 40.0)
                .padding(.bottom, 20.0)
        }
        .transition(.scale)
    }

    
    private func scanTag() {
        nfcReader.scan(modeName: profileManager.currentProfile.name) { payload in
            if payload == tagPhrase {
                NSLog("Toggling block")
                appBlocker.toggleBlocking(for: profileManager.currentProfile)
                isBlocking ? timeBlocked.stopTimer() : timeBlocked.startTimer()
            } else {
                showWrongTagAlert = true
                NSLog("Wrong Tag!\nPayload: \(payload)")
            }
        }
    }
}


#Preview {
    TomatoView()
        .environmentObject(AppBlocker())
        .environmentObject(ProfileManager())
}
