//
//  SoundManager.swift
//  Runvent
//
//  Created by Houssem Farhani on 16.11.25.
//

import AVFoundation
import Foundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    private init() {
        // Configure audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func playChime() {
        // Check if sound is enabled
        guard SettingsManager.shared.soundEnabled else { return }
        
        // Try to load the chime sound file
        guard let url = Bundle.main.url(forResource: "christmas_chime", withExtension: "mp3") ??
                       Bundle.main.url(forResource: "christmas_chime", withExtension: "wav") ??
                       Bundle.main.url(forResource: "christmas_chime", withExtension: "m4a") else {
            print("Warning: Christmas chime sound file not found. Please add 'christmas_chime.mp3' (or .wav/.m4a) to your project.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = 0.7
            audioPlayer?.play()
        } catch {
            print("Error playing chime sound: \(error)")
        }
    }
}

