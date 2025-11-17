//
//  HapticFeedback.swift
//  Runvent
//
//  Created by Houssem Farhani on 16.11.25.
//

import UIKit

struct HapticFeedback {
    private static let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private static let successGenerator = UINotificationFeedbackGenerator()
    
    static func light() {
        guard SettingsManager.shared.hapticsEnabled else { return }
        lightGenerator.impactOccurred()
    }
    
    static func success() {
        guard SettingsManager.shared.hapticsEnabled else { return }
        successGenerator.notificationOccurred(.success)
    }
    
    // Prepare generators for better responsiveness
    static func prepare() {
        lightGenerator.prepare()
        successGenerator.prepare()
    }
}

