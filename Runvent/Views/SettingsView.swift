//
//  SettingsView.swift
//  Runvent
//
//  Created by Houssem Farhani on 16.11.25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: RunventViewModel
    @StateObject private var settings = SettingsManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var showResetAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Game Settings")) {
                    Toggle("Allow Duplicates", isOn: $settings.allowDuplicates)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                
                Section(header: Text("Audio & Haptics")) {
                    Toggle("Sound", isOn: $settings.soundEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                    
                    Toggle("Haptics", isOn: $settings.hapticsEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                }
                
                Section(header: Text("Calendar")) {
                    Button(action: {
                        showResetAlert = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                                .foregroundColor(.red)
                            Text("Reset Calendar")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Reset Calendar", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    viewModel.resetCalendar(allowDuplicates: settings.allowDuplicates)
                }
            } message: {
                Text("This will reassign all kilometers and clear all opened boxes. This action cannot be undone.")
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(RunventViewModel())
}

