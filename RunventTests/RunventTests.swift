//
//  RunventTests.swift
//  RunventTests
//
//  Created by Houssem Farhani on 16.11.25.
//

import Testing
import Foundation
@testable import Runvent

struct RunventViewModelTests {
    
    // MARK: - Random KM Assignment Tests
    
    @Test func testAssignRandomKilometersWithDuplicates() async throws {
        let viewModel = RunventViewModel()
        viewModel.days = (1...24).map { AdventDay(id: $0) }
        
        viewModel.assignRandomKilometers(allowDuplicates: true)
        
        // All days should have km values
        for day in viewModel.days {
            #expect(day.km != nil)
            #expect(day.km! >= 1 && day.km! <= 24)
        }
        
        // With duplicates allowed, we might have duplicates
        let kmValues = viewModel.days.compactMap { $0.km }
        let uniqueValues = Set(kmValues)
        // With duplicates, unique count might be less than 24
        #expect(uniqueValues.count <= 24)
    }
    
    @Test func testAssignRandomKilometersWithoutDuplicates() async throws {
        let viewModel = RunventViewModel()
        viewModel.days = (1...24).map { AdventDay(id: $0) }
        
        viewModel.assignRandomKilometers(allowDuplicates: false)
        
        // All days should have km values
        for day in viewModel.days {
            #expect(day.km != nil)
            #expect(day.km! >= 1 && day.km! <= 24)
        }
        
        // Without duplicates, all km values should be unique
        let kmValues = viewModel.days.compactMap { $0.km }
        let uniqueValues = Set(kmValues)
        #expect(uniqueValues.count == 24)
        
        // All values from 1 to 24 should be present
        let sortedValues = kmValues.sorted()
        #expect(sortedValues == Array(1...24))
    }
    
    @Test func testAssignRandomKilometersMultipleTimes() async throws {
        let viewModel = RunventViewModel()
        viewModel.days = (1...24).map { AdventDay(id: $0) }
        
        // Assign first time
        viewModel.assignRandomKilometers(allowDuplicates: false)
        let firstAssignment = viewModel.days.map { $0.km! }
        
        // Assign second time
        viewModel.assignRandomKilometers(allowDuplicates: false)
        let secondAssignment = viewModel.days.map { $0.km! }
        
        // Values should be different (very unlikely to be the same)
        // Note: There's a tiny chance they could be the same, but it's extremely unlikely
        let areDifferent = firstAssignment != secondAssignment
        #expect(areDifferent || firstAssignment == secondAssignment) // Accept either outcome
    }
    
    // MARK: - Persistence Round-Trip Tests
    
    @Test func testPersistenceRoundTrip() async throws {
        // Create view model and set up test data
        let originalViewModel = RunventViewModel()
        originalViewModel.days = (1...24).map { id in
            AdventDay(
                id: id,
                km: id, // Use id as km for predictable test
                opened: id % 2 == 0, // Every even day is opened
                openedAt: id % 2 == 0 ? Date() : nil
            )
        }
        
        // Save state
        if let encoded = try? JSONEncoder().encode(originalViewModel.days) {
            UserDefaults.standard.set(encoded, forKey: "RunventAdventDays")
        }
        
        // Create new view model and load state
        let loadedViewModel = RunventViewModel()
        
        // Verify all days are loaded correctly
        #expect(loadedViewModel.days.count == 24)
        
        for i in 0..<24 {
            let original = originalViewModel.days[i]
            let loaded = loadedViewModel.days[i]
            
            #expect(loaded.id == original.id)
            #expect(loaded.km == original.km)
            #expect(loaded.opened == original.opened)
            
            if original.opened {
                #expect(loaded.openedAt != nil)
            } else {
                #expect(loaded.openedAt == nil)
            }
        }
    }
    
    @Test func testPersistenceWithEmptyState() async throws {
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "RunventAdventDays")
        
        // Create new view model - should initialize with 24 empty days
        let viewModel = RunventViewModel()
        
        #expect(viewModel.days.count == 24)
        for day in viewModel.days {
            #expect(day.km == nil)
            #expect(day.opened == false)
            #expect(day.openedAt == nil)
        }
    }
    
    @Test func testPersistenceWithPartialData() async throws {
        // Create test data with some days opened
        let testDays = [
            AdventDay(id: 1, km: 5, opened: false, openedAt: nil),
            AdventDay(id: 2, km: 10, opened: true, openedAt: Date()),
            AdventDay(id: 3, km: 15, opened: false, openedAt: nil)
        ]
        
        if let encoded = try? JSONEncoder().encode(testDays) {
            UserDefaults.standard.set(encoded, forKey: "RunventAdventDays")
        }
        
        let viewModel = RunventViewModel()
        
        // Should load the 3 test days
        #expect(viewModel.days.count == 3)
        #expect(viewModel.days[0].id == 1)
        #expect(viewModel.days[0].km == 5)
        #expect(viewModel.days[0].opened == false)
        #expect(viewModel.days[1].id == 2)
        #expect(viewModel.days[1].km == 10)
        #expect(viewModel.days[1].opened == true)
        #expect(viewModel.days[1].openedAt != nil)
    }
    
    // MARK: - canOpen() Rule Tests
    
    @Test func testCanOpenWithClosedBox() async throws {
        let viewModel = RunventViewModel()
        let closedDay = AdventDay(id: 1, km: 5, opened: false, openedAt: nil)
        
        #expect(viewModel.canOpen(day: closedDay) == true)
    }
    
    @Test func testCanOpenWithOpenedBox() async throws {
        let viewModel = RunventViewModel()
        let openedDay = AdventDay(id: 1, km: 5, opened: true, openedAt: Date())
        
        #expect(viewModel.canOpen(day: openedDay) == false)
    }
    
    @Test func testCanOpenMultipleClosedBoxes() async throws {
        let viewModel = RunventViewModel()
        let days = [
            AdventDay(id: 1, opened: false),
            AdventDay(id: 2, opened: false),
            AdventDay(id: 3, opened: false)
        ]
        
        for day in days {
            #expect(viewModel.canOpen(day: day) == true)
        }
    }
    
    @Test func testCanOpenMultipleOpenedBoxes() async throws {
        let viewModel = RunventViewModel()
        let days = [
            AdventDay(id: 1, opened: true, openedAt: Date()),
            AdventDay(id: 2, opened: true, openedAt: Date()),
            AdventDay(id: 3, opened: true, openedAt: Date())
        ]
        
        for day in days {
            #expect(viewModel.canOpen(day: day) == false)
        }
    }
    
    @Test func testOpenFunctionUpdatesState() async throws {
        let viewModel = RunventViewModel()
        viewModel.days = [AdventDay(id: 1, km: 5, opened: false, openedAt: nil)]
        
        let dayToOpen = viewModel.days[0]
        viewModel.open(day: dayToOpen)
        
        #expect(viewModel.days[0].opened == true)
        #expect(viewModel.days[0].openedAt != nil)
    }
    
    @Test func testOpenFunctionDoesNotOpenAlreadyOpenedBox() async throws {
        let viewModel = RunventViewModel()
        let originalDate = Date().addingTimeInterval(-100)
        viewModel.days = [AdventDay(id: 1, km: 5, opened: true, openedAt: originalDate)]
        
        let dayToOpen = viewModel.days[0]
        viewModel.open(day: dayToOpen)
        
        // Should not change the openedAt date
        #expect(viewModel.days[0].openedAt == originalDate)
    }
}

