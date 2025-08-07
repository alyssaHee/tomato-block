//
//  ProfileView.swift
//  Tomato Brick
//
//  Created by Alyssa H on 2025-08-02.
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
    let profile: Profile?
    let onDismiss: () -> Void
    let customIcons = ["happyTomato", "sleepTomato", "selfcareTomato", "nerdTomato", "devilishTomato", "deadTomato", "tastyTomato", "hearteyeTomato"]
    
    init(profile: Profile? = nil, profileManager: ProfileManager, onDismiss: @escaping () -> Void) {
        self.profile = profile
        self.profileManager = profileManager
        self.onDismiss = onDismiss
        _profileName = State(initialValue: profile?.name ?? "")
        _profileIcon = State(initialValue: profile?.icon ?? "happyTomato")
        
        var selection = FamilyActivitySelection()
        selection.applicationTokens = profile?.appTokens ?? []
        selection.categoryTokens = profile?.categoryTokens ?? []
        _activitySelection = State(initialValue: selection)
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
                                .frame(width: 50, height: 50)
                            Text("Choose Icon")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("App Configuration")) {
                    Button(action: { showAppSelection = true }) {
                        Text("Configure Blocked Apps")
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
                
                if profile != nil {
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
                                          title: "Pick an Icon",
                                          imageNames: customIcons)
                    }
            .sheet(isPresented: $showAppSelection) {
                NavigationView {
                    FamilyActivityPicker(selection: $activitySelection)
                        .navigationTitle("Select Apps")
                        .navigationBarItems(trailing: Button("Done") {
                            showAppSelection = false
                        })
                }
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete Mode"),
                    message: Text("Are you sure about this??"),
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
