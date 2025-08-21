//
//  SettingsView.swift
//  Tomato Block
//
//  This file is adapted from Oz Tamir's project Broke, licensed under Apache 2.0
//  Modified by Alyssa Hee on 2025-08-03.
//

import SwiftUI
import FamilyControls
import CoreNFC
import Foundation

struct SettingsView: View {
    @ObservedObject var profileManager: ProfileManager
    @EnvironmentObject private var appBlocker: AppBlocker
    var dismiss: () -> Void
    @State private var showAddProfileView = false
    @State private var editingProfile: Profile?
    
    @StateObject private var nfcReader = NFCReader()
    private let tagPhrase = "MATO"
    
    // @State is for managing local view-specific state
    @State private var showWrongTagAlert = false
    @State private var showCreateTagAlert = false
    @State private var nfcWriteSuccess = false
    
    private var isPad: Bool {
            UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var rows: Int {
        if isPad {
            min(Int(ceil(Double(profileManager.profiles.count + 1) / 7.0)), 2)
        } else {
            min(Int(ceil(Double(profileManager.profiles.count + 1) / 3.0)), 3)
        }
    }
    
    private var isBlocking : Bool {
        get {
            return appBlocker.isBlocking
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading) {
                
                Text("Settings")
                    .font(.kodemono(fontStyle: .title))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 40.0)
                    .padding(.horizontal, 40.0)
                    .foregroundStyle(.primary.opacity(0.85))
                //.textCase(.uppercase)
                
                VStack(alignment: .leading) {
                    Text("Modes")
                        .font(.IBMPlexMonoMedium(fontStyle: .title3))
                        .foregroundColor(Color("settingsTextColour"))
                        .multilineTextAlignment(.leading)
                        .padding(.top, 2.0)
                        .padding(.horizontal, 20.0)
                    
                    
                    modes()
                    
                    
                    Text("Long press on tomato to edit...")
                    .font(.IBMPlexMono(fontStyle: .caption2))
                        //.font(.caption2)
                        .foregroundColor(Color("blurbColour"))
                        .padding(.bottom, 6.0)
                        .padding(.horizontal, 40.0)
                        .padding(.top, 4.0)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.vertical, 10.0)
                .background(Color("settingsDivider"))
                .cornerRadius(12.0)
                .padding(.horizontal, 25.0)
                
            
                Text("Create Tag")
                    .font(.IBMPlexMonoMedium(fontStyle: .title3))
                    .foregroundColor(Color("settingsTextColour"))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 20.0)
                    .padding(.horizontal, 45.0)
                
                createTagButton()
                    .alert(isPresented: $showWrongTagAlert) {
                        Alert(
                            title: Text("Not a Tomato Tag"),
                            message: Text("You can create a new tomato tag in settings"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    .alert("Create Tomato Tag", isPresented: $showCreateTagAlert) {
                        Button("Create") { createTomatoTag() }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Do you want to create a tomato tag?")
                    }
                    .alert("Tag Creation", isPresented: $nfcWriteSuccess) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(nfcWriteSuccess ? "Tomato tag created successfully!" : "Failed to create tomato tag :(. Please try again.")
                    }
        
                
                Spacer()
                
                 
                    Text("Made with 🍅 by Alyssa")
                        .font(.IBMPlexMono(fontStyle: .caption))
                        .foregroundColor(Color("settingsTextColour").opacity(0.7))
                        .padding(.bottom, -2.0)
                        .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            .sheet(item: $editingProfile) { profile in
                ProfileFormView(profile: profile, profileManager: profileManager) {
                    editingProfile = nil
                }
            }
            .sheet(isPresented: $showAddProfileView) {
                ProfileFormView(profileManager: profileManager) {
                    showAddProfileView = false
                }
            }
            .frame(maxHeight: .infinity)
            
            // back button
            Button(action: {
                dismiss()
            }) {
                Image("settingsExit")
            }
            .padding(.top, 30.0)
            .padding(.trailing, 30.0)
            
        }
        .background(Color("settingsBg"))
        .animation(.spring(), value: isBlocking)
        
    }
    
    
    
    @ViewBuilder
    private func modes() -> some View {
        ScrollView {
            // Lazy grid loads view only when needed, much efficient
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 10)], spacing: 10) {
                ForEach(profileManager.profiles) { profile in
                    ProfileCell(profile: profile, isSelected: profile.id == profileManager.currentProfileId)
                        .onTapGesture {
                            profileManager.setCurrentProfile(id: profile.id)
                        }
                        .onLongPressGesture {
                            editingProfile = profile
                        }
                }
                
                ProfileCellBase(name: "Add mode", icon: "addmodeTomato", isSelected: false, isDashed: true)
                    .onTapGesture {
                        showAddProfileView = true
                    }
            }
            .padding(.horizontal, 20.0)
            .padding(.vertical, 3.0)
        }
        .frame(height: CGFloat(rows * 118))
        .padding(.top, -10.0)
    }
    
    private func createTagButton() -> some View {
        Button(action: {
            showCreateTagAlert = true
        }) {
            Image("tagTomato")
                .padding(.horizontal, 55.0)
                .padding(.top, -2.0)
        }
        .disabled(!NFCNDEFReaderSession.readingAvailable)
    }
    
    private func createTomatoTag() {
        nfcReader.write(tagPhrase) { success in
            nfcWriteSuccess = !success
            showCreateTagAlert = false
        }
    }
}

struct ProfileCellBase: View {
    let name: String
    let icon: String
    let isSelected: Bool
    var isDashed: Bool = false

    var body: some View {
        VStack(spacing: 2) {
            Image(icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75, height: 75)

            Text(name)
                .font(.IBMPlexMono(fontStyle: .body))
                .foregroundColor(Color("modeDescriptions"))
                .lineLimit(1)
            

        }
        .frame(width: 85, height: 90)
        .padding(10)
        .background(isSelected ? Color.red.opacity(0.1) : Color.clear)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    isSelected ? Color.red.opacity(0.4) : (isDashed ? Color.clear : Color.clear),
                    style: StrokeStyle(lineWidth: 2, dash: isDashed ? [5] : [])
                )
        )
    }
}

struct ProfileCell: View {
    let profile: Profile
    let isSelected: Bool

    var body: some View {
        ProfileCellBase(
            name: profile.name,
            icon: profile.icon,
            isSelected: isSelected
        )
    }
}
