//
//  Untitled.swift
//  Tomato Block
//
//  Created by Alyssa Hee on 2025-08-02.
//

import SwiftUI

struct CustomImagePicker: View {
    @Binding var selection: String
    let title: String
    let imageNames: [String]
    var autoDismiss: Bool = true

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))]) {
                    ForEach(imageNames, id: \.self) { name in
                        Image(name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 85, height: 85)
                            .padding()
                            .background(selection == name ? Color.blue.opacity(0.2) : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .onTapGesture {
                                selection = name
                                if autoDismiss {
                                    dismiss()
                                }
                            }
                    }
                }
                .padding()
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
