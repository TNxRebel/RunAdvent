//
//  HomeView.swift
//  Runvent
//
//  Created by Houssem Farhani on 16.11.25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: RunventViewModel
    @State private var showSettings = false
    @State private var boxLayouts: [Int: BoxLayout] = [:]
    
    struct BoxLayout {
        let position: CGPoint
        let width: CGFloat
        let height: CGFloat
    }
    
    // Grid-based box definitions (row, column, rowSpan, columnSpan)
    struct BoxGridItem {
        let dayNumber: Int
        let row: Int
        let col: Int
        let rowSpan: Int
        let colSpan: Int
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                Group {
                    if !boxLayouts.isEmpty {
                        // Show boxes with custom layout
                        ZStack {
                            ForEach(viewModel.days) { day in
                                if let layout = boxLayouts[day.id] {
                                    GiftBoxView(day: day, viewModel: viewModel)
                                        .frame(width: layout.width, height: layout.height)
                                        .position(layout.position)
                                }
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    } else {
                        // Fallback: Show simple grid while layout is being generated
                        ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 6), spacing: 12) {
                                ForEach(viewModel.days) { day in
                                    GiftBoxView(day: day, viewModel: viewModel)
                                }
                            }
                            .padding()
                        }
                    }
                }
                .onAppear {
                    // Generate layout immediately when view appears
                    let size = geometry.size
                    if size.width > 0 && size.height > 0 {
                        generateLayout(in: size)
                    }
                }
                .onChange(of: geometry.size) { oldSize, newSize in
                    if newSize.width > 0 && newSize.height > 0 && (oldSize.width != newSize.width || oldSize.height != newSize.height) {
                        generateLayout(in: newSize)
                    }
                }
                .onChange(of: viewModel.days.count) { oldCount, newCount in
                    if newCount > 0 {
                        let size = geometry.size
                        if size.width > 0 && size.height > 0 {
                            generateLayout(in: size)
                        }
                    }
                }
            }
            .navigationTitle("Runvent")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(viewModel)
            }
        }
    }
    
    // Puzzle-like grid layout for 24 boxes
    // Grid: 6 columns x 6 rows (base units)
    // Each box has: (dayNumber, row, col, rowSpan, colSpan)
    private let gridBoxes: [BoxGridItem] = [
        // Row 0 (Top row) - 4 boxes
        BoxGridItem(dayNumber: 1, row: 0, col: 0, rowSpan: 2, colSpan: 2),  // Large square
        BoxGridItem(dayNumber: 2, row: 0, col: 2, rowSpan: 1, colSpan: 1),  // Small
        BoxGridItem(dayNumber: 3, row: 0, col: 3, rowSpan: 1, colSpan: 2),  // Wide
        BoxGridItem(dayNumber: 4, row: 0, col: 5, rowSpan: 2, colSpan: 1),  // Tall
        
        // Row 1 - 3 boxes (some overlap from row 0)
        BoxGridItem(dayNumber: 5, row: 1, col: 2, rowSpan: 1, colSpan: 1),  // Small
        BoxGridItem(dayNumber: 6, row: 1, col: 3, rowSpan: 1, colSpan: 1),  // Small
        BoxGridItem(dayNumber: 7, row: 1, col: 4, rowSpan: 2, colSpan: 1),  // Tall
        
        // Row 2 - 5 boxes
        BoxGridItem(dayNumber: 8, row: 2, col: 0, rowSpan: 1, colSpan: 1),  // Small
        BoxGridItem(dayNumber: 9, row: 2, col: 1, rowSpan: 1, colSpan: 2),  // Wide
        BoxGridItem(dayNumber: 10, row: 2, col: 3, rowSpan: 1, colSpan: 1), // Small
        BoxGridItem(dayNumber: 11, row: 2, col: 5, rowSpan: 1, colSpan: 1), // Small
        
        // Row 3 - 5 boxes
        BoxGridItem(dayNumber: 12, row: 3, col: 0, rowSpan: 1, colSpan: 1), // Small
        BoxGridItem(dayNumber: 13, row: 3, col: 1, rowSpan: 2, colSpan: 1), // Tall
        BoxGridItem(dayNumber: 14, row: 3, col: 2, rowSpan: 1, colSpan: 2), // Wide
        BoxGridItem(dayNumber: 15, row: 3, col: 4, rowSpan: 1, colSpan: 1), // Small
        BoxGridItem(dayNumber: 16, row: 3, col: 5, rowSpan: 2, colSpan: 1), // Tall
        
        // Row 4 - 4 boxes
        BoxGridItem(dayNumber: 17, row: 4, col: 0, rowSpan: 2, colSpan: 1), // Tall
        BoxGridItem(dayNumber: 18, row: 4, col: 2, rowSpan: 1, colSpan: 1), // Small
        BoxGridItem(dayNumber: 19, row: 4, col: 3, rowSpan: 1, colSpan: 2), // Wide
        
        // Row 5 (Bottom row) - 4 boxes
        BoxGridItem(dayNumber: 20, row: 5, col: 1, rowSpan: 1, colSpan: 1), // Small
        BoxGridItem(dayNumber: 21, row: 5, col: 2, rowSpan: 1, colSpan: 1), // Small
        BoxGridItem(dayNumber: 22, row: 5, col: 3, rowSpan: 1, colSpan: 1), // Small
        BoxGridItem(dayNumber: 23, row: 5, col: 4, rowSpan: 1, colSpan: 1), // Small
        BoxGridItem(dayNumber: 24, row: 5, col: 5, rowSpan: 1, colSpan: 1)  // Small
    ]
    
    private func generateLayout(in size: CGSize) {
        guard !viewModel.days.isEmpty else { return }
        guard size.width > 0 && size.height > 0 else { return }
        
        // Spacing between boxes
        let spacing: CGFloat = 6
        
        // Calculate available space
        let padding: CGFloat = 8
        let availableWidth = size.width - (padding * 2)
        let availableHeight = size.height - (padding * 2)
        
        guard availableWidth > 0 && availableHeight > 0 else { return }
        
        // Grid system: 6 columns x 6 rows
        let gridColumns: CGFloat = 6
        let gridRows: CGFloat = 6
        
        // Calculate cell size (including spacing)
        let totalHorizontalSpacing = spacing * (gridColumns - 1)
        let totalVerticalSpacing = spacing * (gridRows - 1)
        
        let cellWidth = (availableWidth - totalHorizontalSpacing) / gridColumns
        let cellHeight = (availableHeight - totalVerticalSpacing) / gridRows
        
        guard cellWidth > 0 && cellHeight > 0 else { return }
        
        var newLayouts: [Int: BoxLayout] = [:]
        
        // Create layouts based on grid definitions
        for boxItem in gridBoxes {
            // Calculate box dimensions
            let boxWidth = (cellWidth * CGFloat(boxItem.colSpan)) + (spacing * CGFloat(boxItem.colSpan - 1))
            let boxHeight = (cellHeight * CGFloat(boxItem.rowSpan)) + (spacing * CGFloat(boxItem.rowSpan - 1))
            
            // Calculate position (top-left corner)
            let x = padding + (cellWidth * CGFloat(boxItem.col)) + (spacing * CGFloat(boxItem.col))
            let y = padding + (cellHeight * CGFloat(boxItem.row)) + (spacing * CGFloat(boxItem.row))
            
            // Position is center of the box (SwiftUI uses center for .position)
            let centerX = x + boxWidth / 2
            let centerY = y + boxHeight / 2
            
            newLayouts[boxItem.dayNumber] = BoxLayout(
                position: CGPoint(x: centerX, y: centerY),
                width: boxWidth,
                height: boxHeight
            )
        }
        
        boxLayouts = newLayouts
    }
}

struct GiftBoxView: View {
    let day: AdventDay
    let viewModel: RunventViewModel
    
    // Animation state variables
    @State private var lidRotationX: Double = 0
    @State private var lidTranslationY: CGFloat = 0
    @State private var scale: Double = 1
    @State private var showKM = false
    @State private var showConfetti = false
    @State private var shadowRadius: CGFloat = 4
    @State private var kmScale: Double = 0.6
    @State private var kmOffsetY: CGFloat = -6
    @State private var kmGlowRadius: CGFloat = 8
    @State private var sparkleScale: Double = 0
    @State private var sparkleOpacity: Double = 1
    @State private var boxGlowOpacity: Double = 0.5
    @State private var showHalo: Bool = false
    
    var body: some View {
        ZStack {
            // Base box layer
            baseBox
            
            // Lid layer (separate ZStack element)
            if !day.opened {
                LidView(dayNumber: day.id, lidRotationX: lidRotationX)
                    .offset(y: lidTranslationY)
            }
            
            // Kilometer number (only when showKM is true)
            if day.opened && showKM, let km = day.km {
                VStack(spacing: 4) {
                    Text("\(km)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text("km")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                }
                .scaleEffect(kmScale)
                .offset(y: kmOffsetY)
                .shadow(color: Color.yellow.opacity(0.8), radius: kmGlowRadius, x: 0, y: 0)
            }
            
            // Golden sparkle effect (behind confetti)
            if showConfetti {
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.yellow.opacity(sparkleOpacity),
                        Color.orange.opacity(sparkleOpacity * 0.6),
                        Color.clear
                    ]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 30
                )
                .frame(width: 60, height: 60)
                .scaleEffect(sparkleScale)
                .opacity(sparkleOpacity)
                .allowsHitTesting(false)
            }
            
            // Confetti animation (centered on the box, on top)
            if showConfetti {
                ZStack {
                    // Try Lottie first if available
                    #if canImport(Lottie)
                    LottieView(name: "confetti", loopMode: .playOnce)
                        .frame(width: 200, height: 200)
                    #else
                    // Fallback to native SwiftUI confetti
                    ConfettiView()
                        .frame(width: 200, height: 200)
                    #endif
                }
                .allowsHitTesting(false)
                .zIndex(100) // Ensure confetti appears on top
            }
        }
        .scaleEffect(scale)
        .onTapGesture {
            // Only allow tap if box is not already opened
            if !day.opened && viewModel.canOpen(day: day) {
                // Light haptic on tap
                HapticFeedback.light()
                animateAnticipation()
            }
        }
        .onAppear {
            // If box is already opened, show KM immediately without animation
            if day.opened {
                showKM = true
                kmScale = 1.0
                kmOffsetY = 0
                startGlowPulse()
                startBoxGlowPulse()
                checkAndShowHalo()
            }
        }
        .onChange(of: day.opened) { oldValue, newValue in
            if newValue && !oldValue {
                // Only animate if transitioning from closed to opened
                animateOpening()
                startBoxGlowPulse()
                checkAndShowHalo()
            }
        }
    }
    
    // MARK: - Base Box
    private var baseBox: some View {
        Group {
            if day.opened {
                ZStack {
                    // Opened box - glowing background with pulsing glow
                    // Color changes based on km value using 4 color ranges
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            boxGradient
                        )
                        .shadow(color: boxShadowColor.opacity(0.6 * boxGlowOpacity), radius: 8, x: 0, y: 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(boxBorderColor.opacity(0.5 * boxGlowOpacity), lineWidth: 2)
                        )
                    
                    // Stronger halo if opened today
                    if showHalo {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.yellow.opacity(0.8),
                                        Color.orange.opacity(0.6),
                                        Color.yellow.opacity(0.8)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                            .shadow(color: Color.yellow.opacity(0.9), radius: 12, x: 0, y: 0)
                            .shadow(color: Color.orange.opacity(0.7), radius: 20, x: 0, y: 0)
                    }
                }
            } else {
                // Closed box base - wrapped gift theme
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: shadowRadius, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            }
        }
    }
    
    // MARK: - Box Colors Based on KM
    
    private var boxGradient: LinearGradient {
        guard let km = day.km else {
            // Default gradient if no km value
            return LinearGradient(
                colors: [
                    Color.orange.opacity(0.8 * boxGlowOpacity),
                    Color.red.opacity(0.6 * boxGlowOpacity)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        let baseColor = ColorUtils.colorForKm(km)
        // Create a gradient using the base color with variations
        let lighterColor = baseColor.opacity(0.9 * boxGlowOpacity)
        let darkerColor = baseColor.opacity(0.7 * boxGlowOpacity)
        
        return LinearGradient(
            colors: [lighterColor, darkerColor],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var boxShadowColor: Color {
        guard let km = day.km else {
            return Color.orange
        }
        return ColorUtils.colorForKm(km)
    }
    
    private var boxBorderColor: Color {
        guard let km = day.km else {
            return Color.yellow
        }
        // Use a lighter version of the km color for the border
        let baseColor = ColorUtils.colorForKm(km)
        return baseColor.opacity(0.8)
    }
    
    // MARK: - Animation
    
    private func animateAnticipation() {
        // Scale down from 1.0 to 0.96 over 0.18s
        withAnimation(.easeInOut(duration: 0.18)) {
            scale = 0.96
            shadowRadius = 6 // Grow shadow slightly
        }
        
        // After 0.18s delay, trigger lid opening animation
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 180_000_000) // 0.18 seconds
            animateLidOpening()
        }
    }
    
    private func animateLidOpening() {
        // Lid rotation: 0 → -80 degrees over 0.35s with custom timing curve
        withAnimation(.timingCurve(0.22, 1, 0.36, 1, duration: 0.35)) {
            lidRotationX = -80
            lidTranslationY = -12 // Translate upward by -12 points
        }
        
        // Open the box in the viewModel after lid starts opening
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
            viewModel.open(day: day)
        }
        
        // After lid finishes opening (0.35s), reveal KM with pop animation
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 350_000_000) // 0.35 seconds
            animateKMReveal()
        }
    }
    
    private func animateKMReveal() {
        // Success haptic on KM reveal
        HapticFeedback.success()
        
        // Play Christmas chime sound
        SoundManager.shared.playChime()
        
        // Set showKM to true with animation context
        withAnimation(.spring(response: 0.35, dampingFraction: 0.45)) {
            showKM = true
            kmScale = 1.15
            kmOffsetY = -6 // Start with upward offset
        }
        
        // Settle to final values
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 160_000_000) // 0.16 seconds
            withAnimation(.spring(response: 0.35, dampingFraction: 0.45)) {
                kmScale = 1.0
                kmOffsetY = 0 // Settle back to 0
            }
        }
        
        // Start repeating glow pulse animation
        startGlowPulse()
        
        // Trigger confetti animation right at reveal stage
        animateConfetti()
    }
    
    private func animateConfetti() {
        // Show confetti animation with fade-in
        showConfetti = true
        print("🎉 Confetti triggered! showConfetti = \(showConfetti)")
        
        // Animate golden sparkle: scale and fade
        withAnimation(.easeOut(duration: 0.6)) {
            sparkleScale = 1.5
            sparkleOpacity = 0
        }
        
        // Reset sparkle for potential reuse
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 600_000_000) // 0.6 seconds
            sparkleScale = 0
            sparkleOpacity = 1
        }
        
        // Hide confetti automatically after 1.3 seconds
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1_300_000_000) // 1.3 seconds
            withAnimation(.easeOut(duration: 0.2)) {
                showConfetti = false
            }
        }
    }
    
    private func startGlowPulse() {
        // Repeating shadow pulse animation
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            kmGlowRadius = 12
        }
    }
    
    private func startBoxGlowPulse() {
        // Gentle pulsing glow: opacity 0.5 → 1.0 → 0.5 over 2.4s
        withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
            boxGlowOpacity = 1.0
        }
    }
    
    private func checkAndShowHalo() {
        // Check if box was opened today
        guard let openedAt = day.openedAt else { return }
        
        let calendar = Calendar.current
        if calendar.isDateInToday(openedAt) {
            // Show stronger halo for 6 seconds with fade-in
            withAnimation(.easeIn(duration: 0.3)) {
                showHalo = true
            }
            
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 6_000_000_000) // 6 seconds
                withAnimation(.easeOut(duration: 0.5)) {
                    showHalo = false
                }
            }
        }
    }
    
    private func animateOpening() {
        // Scale animation (bounce back and up) - only if not already animating
        // This prevents conflicts with anticipation animation
        if scale != 0.96 {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = 1.1
                shadowRadius = 8
            }
            
            // Reset scale and shadow
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    scale = 1.0
                    shadowRadius = 4
                }
            }
        } else {
            // If coming from anticipation, smoothly transition
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = 1.1
                shadowRadius = 8
            }
            
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    scale = 1.0
                    shadowRadius = 4
                }
            }
        }
    }
}

// MARK: - LidView

struct LidView: View {
    let dayNumber: Int
    let lidRotationX: Double
    
    var body: some View {
        ZStack {
            // Lid with slightly different styling
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )
            
            VStack(spacing: 4) {
                Image(systemName: "gift.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.9))
                
                Text("\(dayNumber)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .rotation3DEffect(
            .degrees(lidRotationX),
            axis: (x: 1, y: 0, z: 0),
            anchor: .bottom
        )
    }
}

#Preview {
    let viewModel = RunventViewModel()
    return HomeView()
        .environmentObject(viewModel)
}

