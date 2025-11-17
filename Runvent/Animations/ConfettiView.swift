//
//  ConfettiView.swift
//  Runvent
//
//  Created by Houssem Farhani on 16.11.25.
//

import SwiftUI

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(
                            x: particle.offsetX + geometry.size.width / 2,
                            y: particle.offsetY + geometry.size.height / 2
                        )
                        .opacity(particle.opacity)
                }
            }
            .onAppear {
                createParticles()
                animateParticles()
            }
        }
    }
    
    private func createParticles() {
        let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink]
        
        particles = (0..<40).map { _ in
            ConfettiParticle(
                id: UUID(),
                offsetX: 0,
                offsetY: 0,
                color: colors.randomElement() ?? .red,
                size: CGFloat.random(in: 5...10),
                targetOffsetX: CGFloat.random(in: -100...100),
                targetOffsetY: CGFloat.random(in: -100...100),
                opacity: 1.0
            )
        }
    }
    
    private func animateParticles() {
        withAnimation(.easeOut(duration: 1.3)) {
            for i in particles.indices {
                particles[i].offsetX = particles[i].targetOffsetX
                particles[i].offsetY = particles[i].targetOffsetY
                particles[i].opacity = 0
            }
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id: UUID
    var offsetX: CGFloat
    var offsetY: CGFloat
    let color: Color
    let size: CGFloat
    let targetOffsetX: CGFloat
    let targetOffsetY: CGFloat
    var opacity: Double
}

