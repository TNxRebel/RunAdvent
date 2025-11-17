//
//  LottieView.swift
//  Runvent
//
//  Created by Houssem Farhani on 16.11.25.
//

import SwiftUI

#if canImport(Lottie)
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    
    init(name: String, loopMode: LottieLoopMode = .loop, animationSpeed: CGFloat = 1.0) {
        self.name = name
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        
        // Try to load animation by name first
        if let animation = LottieAnimation.named(name) {
            animationView.animation = animation
        } else if let path = Bundle.main.path(forResource: name, ofType: "json") {
            // Try loading from bundle path
            animationView.animation = LottieAnimation.filepath(path)
        } else {
            // If animation not found, create a placeholder
            print("Warning: Lottie animation '\(name)' not found")
        }
        
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update if needed
    }
}

#else
// Placeholder for when Lottie is not available
enum LottieLoopMode {
    case loop
    case playOnce
}

struct LottieView: View {
    let name: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat
    
    init(name: String, loopMode: LottieLoopMode = .loop, animationSpeed: CGFloat = 1.0) {
        self.name = name
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
    }
    
    var body: some View {
        // Placeholder view when Lottie is not available
        Color.clear
            .onAppear {
                print("Warning: Lottie package not installed. Add it via: File > Add Package Dependencies > https://github.com/airbnb/lottie-ios.git")
            }
    }
}
#endif

