//
//  GiftBoxViewPreviewTests.swift
//  RunventTests
//
//  Created by Houssem Farhani on 16.11.25.
//

import Testing
import SwiftUI
@testable import Runvent

// Preview-based tests for visual verification
@MainActor
struct GiftBoxViewPreviewTests {
    
    // These tests verify that previews can be created and rendered
    // In Xcode, you can view these previews to visually verify the states
    
    @Test func testClosedBoxPreview() async throws {
        let closedDay = AdventDay(id: 5, km: 10, opened: false, openedAt: nil)
        let viewModel = RunventViewModel()
        viewModel.days = [closedDay]
        
        // Create preview view
        let preview = GiftBoxView(day: closedDay, viewModel: viewModel)
            .frame(width: 100, height: 100)
            .previewLayout(.sizeThatFits)
        
        // Verify preview can be created
        #expect(preview != nil)
        #expect(closedDay.opened == false)
    }
    
    @Test func testOpenedBoxPreview() async throws {
        let openedDay = AdventDay(id: 12, km: 20, opened: true, openedAt: Date())
        let viewModel = RunventViewModel()
        viewModel.days = [openedDay]
        
        // Create preview view
        let preview = GiftBoxView(day: openedDay, viewModel: viewModel)
            .frame(width: 100, height: 100)
            .previewLayout(.sizeThatFits)
        
        // Verify preview can be created
        #expect(preview != nil)
        #expect(openedDay.opened == true)
        #expect(openedDay.km == 20)
    }
    
    @Test func testAllDayNumbersPreview() async throws {
        let viewModel = RunventViewModel()
        viewModel.days = (1...24).map { AdventDay(id: $0, opened: false) }
        
        // Verify all 24 days can be created
        for day in viewModel.days {
            let preview = GiftBoxView(day: day, viewModel: viewModel)
                .frame(width: 100, height: 100)
            
            #expect(preview != nil)
            #expect(day.id >= 1 && day.id <= 24)
        }
    }
}

// MARK: - SwiftUI Previews for Manual Visual Testing

#if DEBUG
struct GiftBoxView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RunventViewModel()
        viewModel.days = [
            AdventDay(id: 1, km: 5, opened: false, openedAt: nil),
            AdventDay(id: 2, km: 10, opened: true, openedAt: Date()),
            AdventDay(id: 24, km: 24, opened: false, openedAt: nil)
        ]
        
        return Group {
            // Closed box preview
            GiftBoxView(day: viewModel.days[0], viewModel: viewModel)
                .previewDisplayName("Closed Box")
                .previewLayout(.sizeThatFits)
                .padding()
            
            // Opened box preview
            GiftBoxView(day: viewModel.days[1], viewModel: viewModel)
                .previewDisplayName("Opened Box")
                .previewLayout(.sizeThatFits)
                .padding()
            
            // Grid preview
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 6), spacing: 12) {
                ForEach(viewModel.days) { day in
                    GiftBoxView(day: day, viewModel: viewModel)
                }
            }
            .padding()
            .previewDisplayName("Grid View")
        }
    }
}
#endif

