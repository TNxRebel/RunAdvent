//
//  RunventViewModel.swift
//  Runvent
//
//  Created by Houssem Farhani on 16.11.25.
//

import Foundation
import SwiftUI
import Combine

class RunventViewModel: ObservableObject {
    @Published var days: [AdventDay] = []
    
    private let userDefaultsKey = "RunventAdventDays"
    
    init() {
        loadState()
        if days.isEmpty {
            // Initialize with 24 days if no saved state exists
            days = (1...24).map { AdventDay(id: $0) }
            saveState()
        }
    }
    
    // MARK: - Persistence
    
    private func saveState() {
        if let encoded = try? JSONEncoder().encode(days) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadState() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([AdventDay].self, from: data) {
            days = decoded
        }
    }
    
    // MARK: - Functions
    
    func assignRandomKilometers(allowDuplicates: Bool) {
        let kmValues = Array(1...24)
        
        if allowDuplicates {
            // Assign random kilometers with possible duplicates
            days = days.map { day in
                var updatedDay = day
                updatedDay.km = kmValues.randomElement()
                return updatedDay
            }
        } else {
            // Assign unique random kilometers
            var shuffledKm = kmValues.shuffled()
            days = days.map { day in
                var updatedDay = day
                if !shuffledKm.isEmpty {
                    updatedDay.km = shuffledKm.removeFirst()
                }
                return updatedDay
            }
        }
        
        saveState()
    }
    
    func canOpen(day: AdventDay) -> Bool {
        // Can open if not already opened
        return !day.opened
    }
    
    func open(day: AdventDay) {
        guard let index = days.firstIndex(where: { $0.id == day.id }) else { return }
        guard canOpen(day: day) else { return }
        
        days[index].opened = true
        days[index].openedAt = Date()
        saveState()
    }
    
    func resetCalendar(allowDuplicates: Bool) {
        // Reassign kilometers
        assignRandomKilometers(allowDuplicates: allowDuplicates)
        
        // Clear all opened boxes
        days = days.map { day in
            var updatedDay = day
            updatedDay.opened = false
            updatedDay.openedAt = nil
            return updatedDay
        }
        
        saveState()
    }
}

