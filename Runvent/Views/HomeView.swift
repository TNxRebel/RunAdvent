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
    
    // Hardcoded fixed layouts for each day (1-24)
    // Each entry: (widthMultiplier, heightMultiplier, offsetXMultiplier, offsetYMultiplier)
    private let fixedLayouts: [Int: (width: CGFloat, height: CGFloat, offsetX: CGFloat, offsetY: CGFloat)] = [
        1: (1.15, 0.95, -0.12, 0.08),
        2: (0.85, 1.25, 0.15, -0.10),
        3: (1.30, 0.88, -0.08, 0.12),
        4: (0.92, 1.18, 0.10, -0.15),
        5: (1.08, 1.05, -0.05, 0.05),
        6: (0.78, 1.32, 0.18, -0.08),
        7: (1.22, 0.92, -0.10, 0.10),
        8: (0.88, 1.28, 0.12, -0.12),
        9: (1.05, 1.10, -0.08, 0.15),
        10: (0.95, 1.15, 0.08, -0.10),
        11: (1.18, 0.98, -0.15, 0.08),
        12: (0.82, 1.22, 0.10, -0.12),
        13: (1.12, 1.02, -0.12, 0.10),
        14: (0.90, 1.20, 0.15, -0.08),
        15: (1.25, 0.90, -0.10, 0.12),
        16: (0.85, 1.28, 0.12, -0.15),
        17: (1.08, 1.08, -0.08, 0.08),
        18: (0.92, 1.15, 0.10, -0.10),
        19: (1.20, 0.95, -0.12, 0.15),
        20: (0.88, 1.25, 0.08, -0.12),
        21: (1.15, 1.00, -0.10, 0.10),
        22: (0.95, 1.18, 0.15, -0.08),
        23: (1.28, 0.88, -0.08, 0.12),
        24: (0.82, 1.30, 0.12, -0.15)
    ]
    
    private func generateLayout(in size: CGSize) {
        guard !viewModel.days.isEmpty else { return }
        guard size.width > 0 && size.height > 0 else { return }
        
        let padding: CGFloat = 10
        let availableWidth = max(0, size.width - (padding * 2))
        let availableHeight = max(0, size.height - (padding * 2))
        
        guard availableWidth > 0 && availableHeight > 0 else { return }
        
        // Create a flexible grid-like layout with varying sizes
        let columns = 6
        let rows = 4
        let cellWidth = availableWidth / CGFloat(columns)
        let cellHeight = availableHeight / CGFloat(rows)
        
        guard cellWidth > 0 && cellHeight > 0 else { return }
        
        var newLayouts: [Int: BoxLayout] = [:]
        
        for day in viewModel.days {
            // Get grid position based on day ID (1-24)
            let index = day.id - 1
            let row = index / columns
            let col = index % columns
            
            // Get fixed layout multipliers for this day
            let layout = fixedLayouts[day.id] ?? (1.0, 1.0, 0.0, 0.0)
            
            // Calculate size using fixed multipliers
            var width = cellWidth * layout.width
            var height = cellHeight * layout.height
            
            // Ensure minimum sizes
            width = max(30, width)
            height = max(30, height)
            
            // Calculate position (center of cell with fixed offset)
            let cellCenterX = padding + CGFloat(col) * cellWidth + cellWidth / 2
            let cellCenterY = padding + CGFloat(row) * cellHeight + cellHeight / 2
            
            // Apply fixed offset multipliers
            let maxOffsetX = min(cellWidth * 0.2, cellWidth / 2 - width / 2)
            let maxOffsetY = min(cellHeight * 0.2, cellHeight / 2 - height / 2)
            
            let offsetX = layout.offsetX * maxOffsetX
            let offsetY = layout.offsetY * maxOffsetY
            
            let position = CGPoint(
                x: cellCenterX + offsetX,
                y: cellCenterY + offsetY
            )
            
            // Ensure position stays within bounds
            let minX = padding + width / 2
            let maxX = size.width - padding - width / 2
            let minY = padding + height / 2
            let maxY = size.height - padding - height / 2
            
            let finalX = max(minX, min(maxX, position.x))
            let finalY = max(minY, min(maxY, position.y))
            
            newLayouts[day.id] = BoxLayout(
                position: CGPoint(x: finalX, y: finalY),
                width: width,
                height: height
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
        .aspectRatio(1, contentMode: .fit)
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

