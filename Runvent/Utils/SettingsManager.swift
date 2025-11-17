//
//  SettingsManager.swift
//  Runvent
//
//  Created by Houssem Farhani on 16.11.25.
//

import Foundation
import Combine

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @Published var allowDuplicates: Bool {
        didSet {
            UserDefaults.standard.set(allowDuplicates, forKey: "allowDuplicates")
        }
    }
    
    @Published var soundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(soundEnabled, forKey: "soundEnabled")
        }
    }
    
    @Published var hapticsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(hapticsEnabled, forKey: "hapticsEnabled")
        }
    }
    
    private init() {
        self.allowDuplicates = UserDefaults.standard.bool(forKey: "allowDuplicates")
        self.soundEnabled = UserDefaults.standard.object(forKey: "soundEnabled") as? Bool ?? true
        self.hapticsEnabled = UserDefaults.standard.object(forKey: "hapticsEnabled") as? Bool ?? true
    }
}

