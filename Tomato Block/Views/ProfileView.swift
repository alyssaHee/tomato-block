//
//  ProfileView.swift
//  Tomato Block
//
//  This file is adapted from Oz Tamir's project Broke, licensed under Apache 2.0
//  Modified by Alyssa Hee on 2025-08-02.
//

import SwiftUI
import FamilyControls

struct ProfileFormView: View {
    @ObservedObject var profileManager: ProfileManager
    @State private var profileName: String
    @State private var showImagePicker = false
    @State private var profileIcon = "happyTomato"
    @State private var showAppSelection = false
    @State private var activitySelection: FamilyActivitySelection
    @State private var showDeleteConfirmation = false
    @State private var wasSelected = false
    let profile: Profile?
    let onDismiss: () -> Void
    let customIcons = ["defaultTomato", "happyTomato", "nerdTomato", "sleepTomato", "selfcareTomato", "devilishTomato", "deadTomato", "tastyTomato", "hearteyeTomato", "gymTomato", "moneyTomato", "sunglassTomato"]
    
    init(profile: Profile? = nil, profileManager: ProfileManager, onDismiss: @escaping () -> Void) {
        self.profile = profile
        self.profileManager = profileManager
        self.onDismiss = onDismiss
        _profileName = State(initialValue: profile?.name ?? "")
        _profileIcon = State(initialValue: profile?.icon ?? "defaultTomato")
        
        var selection = FamilyActivitySelection()
        selection.applicationTokens = profile?.appTokens ?? []
        selection.categoryTokens = profile?.categoryTokens ?? []
        _activitySelection = State(initialValue: selection)
        
        if(profile == nil) {
            wasSelected = false
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Mode Details")) {
                    VStack(alignment: .leading) {
                        Text("Mode Name")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("Enter mode name", text: $profileName)
                    }
                    
                    Button(action: { showImagePicker = true }) {
                        HStack {
                            Image(profileIcon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 45)
                                .padding(.bottom, 2.0)
                            
                            Text("Choose Icon")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack {
                        Text("Total Block Sessions: ")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        profile == nil ? Text("0") : Text("\(profileManager.currentProfile.totalSessions)")
                    }

                }
                
                
                Section(header: Text("App Configuration")) {
                    Button(action: { showAppSelection = true }) {
                        HStack {
                            Text("Configure Blocked Apps")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Blocked Apps:")
                            Spacer()
                            Text("\(activitySelection.applicationTokens.count)")
                                .fontWeight(.bold)
                        }
                        HStack {
                            Text("Blocked Categories:")
                            Spacer()
                            Text("\(activitySelection.categoryTokens.count)")
                                .fontWeight(.bold)
                        }
                    }
                }
                
                Section(header: Text("Block Method")) {
                    Button(action: {
                        profileManager.updateProfile(id: profileManager.currentProfileId!, methodSelected: "NFC")
                        wasSelected = true
                        NSLog("NFC selected")
                        NSLog("\(profileManager.currentProfile.methodSelected)")
                    }){
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Tomato Tag (NFC)")
                                    .foregroundColor(.primary)
                                Text("Requires device with NFC capabilities")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                            Spacer()
                            
                            if profileManager.currentProfile.methodSelected == "NFC" || (profile == nil && !wasSelected) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "circle")
                                    .font(.system(size: 24))
                                    .foregroundColor(.secondary)
                            }
                            
                        }
                    }
                    
                    Button(action: {
                        profileManager.updateProfile(id: profileManager.currentProfileId!, methodSelected: "Manual")
                        wasSelected = true
                        NSLog("Manual selected")
                        NSLog("\(profileManager.currentProfile.methodSelected)")
                    }){
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Manual")
                                    .foregroundColor(.primary)
                                Text("Block/unblock directly through app")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            }
                            Spacer()
                            
                            if profileManager.currentProfile.methodSelected == "Manual" {
                                if profile == nil && !wasSelected {
                                    Image(systemName: "circle")
                                        .font(.system(size: 24))
                                        .foregroundColor(.secondary)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.blue)
                                }
                            } else {
                                Image(systemName: "circle")
                                    .font(.system(size: 24))
                                    .foregroundColor(.secondary)
                            }
                            
                        }
                    }
                    
                }
                
                if (profile != nil && profileManager.profiles.count > 1){
                    Section {
                        Button(action: { showDeleteConfirmation = true }) {
                            Text("Delete Mode")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle(profile == nil ? "Add Mode" : "Edit Mode")
            .navigationBarItems(
                leading: Button("Cancel", action: onDismiss),
                trailing: Button("Save", action: handleSave)
                    .disabled(profileName.isEmpty)
            )
            .sheet(isPresented: $showImagePicker) {
                        CustomImagePicker(selection: $profileIcon,
                                          title: "Pick an icon!",
                                          imageNames: customIcons)
                    }
            .sheet(isPresented: $showAppSelection) {
                NavigationView {
                    FamilyActivityPicker(selection: $activitySelection)
                        .navigationBarItems(trailing: Button("Done!") {
                            showAppSelection = false
                        })
                }
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete Mode"),
                    message: Text("Are you sure about this?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let profile = profile {
                            profileManager.deleteProfile(withId: profile.id)
                        }
                        onDismiss()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private func handleSave() {
        if let existingProfile = profile {
            profileManager.updateProfile(
                id: existingProfile.id,
                name: profileName,
                appTokens: activitySelection.applicationTokens,
                categoryTokens: activitySelection.categoryTokens,
                icon: profileIcon
            )
        } else {
            let newProfile = Profile(
                name: profileName,
                appTokens: activitySelection.applicationTokens,
                categoryTokens: activitySelection.categoryTokens,
                icon: profileIcon
            )
            profileManager.addProfile(newProfile: newProfile)
        }
        onDismiss()
    }
}
