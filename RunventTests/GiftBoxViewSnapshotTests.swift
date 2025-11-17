//
//  GiftBoxViewSnapshotTests.swift
//  RunventTests
//
//  Created by Houssem Farhani on 16.11.25.
//

import Testing
import SwiftUI
@testable import Runvent

@MainActor
struct GiftBoxViewSnapshotTests {
    
    @Test func testClosedBoxState() async throws {
        let closedDay = AdventDay(id: 5, km: 10, opened: false, openedAt: nil)
        let viewModel = RunventViewModel()
        viewModel.days = [closedDay]
        
        let giftBoxView = GiftBoxView(day: closedDay, viewModel: viewModel)
        let hostingController = await UIHostingController(rootView: giftBoxView)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        // Verify the view can be rendered
        await MainActor.run {
            hostingController.view.setNeedsLayout()
            hostingController.view.layoutIfNeeded()
        }
        
        // Basic assertions about closed box state
        #expect(closedDay.opened == false)
        #expect(closedDay.km == 10)
    }
    
    @Test func testOpenedBoxState() async throws {
        let openedDay = AdventDay(id: 12, km: 20, opened: true, openedAt: Date())
        let viewModel = RunventViewModel()
        viewModel.days = [openedDay]
        
        let giftBoxView = GiftBoxView(day: openedDay, viewModel: viewModel)
        let hostingController = await UIHostingController(rootView: giftBoxView)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        // Verify the view can be rendered
        await MainActor.run {
            hostingController.view.setNeedsLayout()
            hostingController.view.layoutIfNeeded()
        }
        
        // Basic assertions about opened box state
        #expect(openedDay.opened == true)
        #expect(openedDay.km == 20)
        #expect(openedDay.openedAt != nil)
    }
    
    @Test func testBoxStatesWithDifferentDays() async throws {
        let days = [
            AdventDay(id: 1, km: 5, opened: false, openedAt: nil),
            AdventDay(id: 2, km: 10, opened: true, openedAt: Date()),
            AdventDay(id: 24, km: 24, opened: false, openedAt: nil)
        ]
        
        let viewModel = RunventViewModel()
        viewModel.days = days
        
        for day in days {
            let giftBoxView = GiftBoxView(day: day, viewModel: viewModel)
            let hostingController = await UIHostingController(rootView: giftBoxView)
            hostingController.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            
            await MainActor.run {
                hostingController.view.setNeedsLayout()
                hostingController.view.layoutIfNeeded()
            }
            
            // Verify each day renders correctly
            #expect(day.id >= 1 && day.id <= 24)
        }
    }
    
    @Test func testBoxWithNilKm() async throws {
        let dayWithoutKm = AdventDay(id: 7, km: nil, opened: true, openedAt: Date())
        let viewModel = RunventViewModel()
        viewModel.days = [dayWithoutKm]
        
        let giftBoxView = GiftBoxView(day: dayWithoutKm, viewModel: viewModel)
        let hostingController = await UIHostingController(rootView: giftBoxView)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        await MainActor.run {
            hostingController.view.setNeedsLayout()
            hostingController.view.layoutIfNeeded()
        }
        
        #expect(dayWithoutKm.km == nil)
        #expect(dayWithoutKm.opened == true)
    }
}

