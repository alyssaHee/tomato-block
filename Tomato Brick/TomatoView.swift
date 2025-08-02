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
    
    // @StateObject is for managing reference types like classes unlike @State which manages simple variables
    @StateObject private var nfcReader = NFCReader()
    private let tagPhrase = "MATO"
    
    // @State is for managing local view-specific state
    @State private var showWrongTagAlert = false
    @State private var showCreateTagAlert = false
    @State private var nfcWriteSuccess = false
    
    private var isBlocking : Bool {
        get {
            return appBlocker.isBlocking
        }
    }
    
    var body: some View {
        
            NavigationStack {
                UnblockedView()
        }
        
    }
}

struct UnblockedView: View {
    var body: some View {
        ZStack() {
            Color(red: 0.89, green: 0.87, blue: 0.87)
                .ignoresSafeArea()
            

            
            VStack {
                Spacer()
                    .frame(height: 120.0)
                
                Text("Protect Your Energy")
                    .font(.kodemono(fontStyle: .title2))
                    .foregroundStyle(.white)
                    .padding(.bottom, 4.0)
                    //.textCase(.uppercase)
                    
                Text("Tap to Block")
                    .font(.IBMPlexMono())
                    .foregroundColor(Color(red:0.84, green: 0.41, blue:0.41))
                    .padding(.bottom, 4.0)
                
                // tomato
                Image("defaultTomato")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 40.0)
                    .padding(.bottom, 20.0)
                    
                    
                // drop down menu to choose mode
                Menu("Default mode") {
                    /*@START_MENU_TOKEN@*/Text("Work Mode")/*@END_MENU_TOKEN@*/
                    /*@START_MENU_TOKEN@*/Text("School Mode")/*@END_MENU_TOKEN@*/
                    /*@START_MENU_TOKEN@*/Text("Sleep")/*@END_MENU_TOKEN@*/
                }
                .padding(.horizontal)
                .font(.IBMPlexMono(fontStyle: .headline))
                .foregroundStyle(.black)
                .border(.black, width: 1.0)
                
                Spacer()
            }
            .padding(.horizontal, 24.0)
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 30)
                                    .tint(Color(red: 0.67, green: 0.59, blue: 0.59))
                        }
                    .padding([.top, .trailing])
                    }
            }
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack() {
            Color(red: 0.97, green: 0.96, blue: 0.96)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Settings")
                    .font(.kodemono(fontStyle: .title))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
                    //.textCase(.uppercase)
                
           
                    Text("Modes")
                        .font(.IBMPlexMono(fontStyle: .title3))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.top, -3.0)
                    
                   
                    
                HStack() {
                    VStack() {
                        Image("happyTomato")
                        Text("Default")
                            .font(.IBMPlexMono(fontStyle: .body))
                    }
                    
                    Image("addmodeTomato")
                }
                
                Spacer()
            }
            .padding(.leading, 40.0)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            
            // back button
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("settingsExit")
                        }
                        .padding([.top, .trailing])
                    }
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}



#Preview {
    TomatoView()
}
