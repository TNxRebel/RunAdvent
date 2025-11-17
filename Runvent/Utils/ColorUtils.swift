//
//  ColorUtils.swift
//  Runvent
//
//  Created by Houssem Farhani on 16.11.25.
//

import SwiftUI

struct ColorUtils {
    /// Returns a color based on the km value using specific color ranges
    /// - Parameter km: The kilometer value (1-24)
    /// - Returns: A color based on the range:
    ///   - 1-6: #02864A (green)
    ///   - 7-12: #573CFA (purple)
    ///   - 13-18: #FB8D1A (orange)
    ///   - 19-24: #E8083E (red)
    static func colorForKm(_ km: Int) -> Color {
        // Clamp value between 1 and 24
        let clampedKm = max(1, min(24, km))
        
        switch clampedKm {
        case 1...6:
            // Green: #02864A
            return Color(hex: "02864A")
        case 7...12:
            // Purple: #573CFA
            return Color(hex: "573CFA")
        case 13...18:
            // Orange: #FB8D1A
            return Color(hex: "FB8D1A")
        case 19...24:
            // Red: #E8083E
            return Color(hex: "E8083E")
        default:
            return Color(hex: "02864A") // Default to green
        }
    }
}

extension Color {
    /// Creates a Color from a hex string
    /// - Parameter hex: Hex string (e.g., "02864A" or "#02864A")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

