//
//  SettingsView.swift
//  Tomato Brick
//
//  Created by Alyssa H on 2025-08-03.
//

import SwiftUI
import FamilyControls

struct SettingsView: View {
    @ObservedObject var profileManager: ProfileManager
    var dismiss: () -> Void
    @State private var showAddProfileView = false
    @State private var editingProfile: Profile?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading) {
                Text("Settings")
                    .font(.kodemono(fontStyle: .title))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
                    .padding(.top, 40.0)
                    .padding(.horizontal, 40)
                //.textCase(.uppercase)
                
                
                Text("Modes")
                    .font(.IBMPlexMono(fontStyle: .title2))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.top, -3.0)
                    .padding(.horizontal, 40)
                
                Text("Long press on a profile to edit...")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.7))
                    .padding(.bottom, 8)
                    .padding(.horizontal, 40)
                
                ScrollView {
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
                }
                .frame(height: 240)
                .padding(.horizontal, 40)
                
                
                Text("Create Tag")
                    .font(.IBMPlexMono(fontStyle: .title2))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 5.0)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                
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
                .padding(.top, 30)
                .padding(.trailing, 30)
                
        }
        .background(Color("settingsBg"))
        
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
                .lineLimit(1)
            

        }
        .frame(width: 90, height: 90)
        .padding(10)
        .background(isSelected ? Color.red.opacity(0.1) : Color.clear)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    isSelected ? Color.clear : (isDashed ? Color.clear : Color.clear),
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
