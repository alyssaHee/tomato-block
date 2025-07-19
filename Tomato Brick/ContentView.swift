//
//  ContentView.swift
//  Tomato Brick
//
//  Created by Alyssa H on 2025-07-15.
//

import SwiftUI

struct ContentView: View {
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
                Menu(/*@START_MENU_TOKEN@*/"Menu"/*@END_MENU_TOKEN@*/) {
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
                    .padding(.top)
                    .padding(.trailing)
                    }
            }
            
            
                
                    
            
    }
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Halloo")
    }
}

#Preview {
    ContentView()
}
