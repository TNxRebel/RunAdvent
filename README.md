# 🎄🏃 RunAdvent

This project is a cool but tough challenge for runners.
Most Advent calendars give you chocolates or small gifts, but this one gives you a daily running mission.

Each day, you open a “box” and get a random distance between 1 km and 24 km.
You never know what you’ll get: could be an easy 3 km, or suddenly a 20+ km push.

This randomness makes the challenge more fun and avoids overloading the runner.
Instead of stacking huge distances in the final week (like the traditional 1–24 km progression that ends with ~150 km in 7 days), the difficulty is spread more evenly across the whole month.

You’ll still end up with around 300 km total, but with a balanced distribution of tough and easy days.
A perfect mix of surprise, discipline, and endurance.
## Features

- 🎄 24 interactive Advent day boxes
- 🎁 Smooth gift box opening animations with lid rotation and confetti effects
- 🎨 Color-coded boxes based on kilometer values (4 distinct color ranges)
- 🔊 Christmas chime sound effects
- 📳 Haptic feedback for enhanced user experience
- 💾 Persistent state management with UserDefaults
- ⚙️ Customizable settings (sound, haptics, duplicate kilometers)

## Tech Stack

### Core Technologies
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Platform**: iOS
- **Minimum iOS Version**: iOS 17.0+

### Architecture & Design Patterns
- **Architecture**: MVVM (Model-View-ViewModel)
- **State Management**: Combine Framework
  - `ObservableObject` for view models
  - `@Published` properties for reactive updates
  - `@StateObject` and `@EnvironmentObject` for dependency injection

### Frameworks & Libraries

#### Core Frameworks
- **SwiftUI**: Declarative UI framework for building the interface
- **Foundation**: Core data structures and utilities
- **Combine**: Reactive programming for state management
- **UIKit**: Haptic feedback integration
  - `UINotificationFeedbackGenerator` for success haptics
  - `UIImpactFeedbackGenerator` for light haptics

#### Media & Animation
- **AVFoundation**: Audio playback
  - `AVAudioPlayer` for Christmas chime sound effects
  - `AVAudioSession` for audio session management
- **Lottie** (Optional): Advanced animation support
  - Used for confetti animations
  - Graceful fallback to native SwiftUI animations if not available

#### Persistence
- **UserDefaults**: Local data storage
  - `JSONEncoder` / `JSONDecoder` for serialization
  - Stores Advent day states, settings, and preferences

#### Testing
- **Swift Testing**: Modern testing framework
  - Unit tests for ViewModel logic
  - Snapshot tests for view rendering
  - Preview tests for visual verification

### Project Structure

```
Runvent/
├── Models/
│   └── AdventDay.swift          # Data model for Advent days
├── Views/
│   ├── HomeView.swift           # Main calendar view
│   └── SettingsView.swift       # Settings and preferences
├── ViewModels/
│   └── RunventViewModel.swift   # Business logic and state management
├── Animations/
│   ├── LottieView.swift         # Lottie animation wrapper
│   └── ConfettiView.swift       # Native confetti fallback
└── Utils/
    ├── ColorUtils.swift         # Color utilities for KM-based coloring
    ├── HapticFeedback.swift     # Haptic feedback manager
    ├── SoundManager.swift       # Audio playback manager
    └── SettingsManager.swift    # Settings persistence manager
```

### Key Features Implementation

- **Custom Layout System**: Fixed, hardcoded box positions and sizes for consistent layout
- **Advanced Animations**: 
  - Tap-down anticipation with scale effects
  - 3D lid rotation with custom timing curves
  - Spring-based KM reveal animations
  - Pulsing glow effects for opened boxes
- **Responsive Design**: GeometryReader-based layout that adapts to screen sizes
- **Accessibility**: System color support with light/dark mode compatibility

## Requirements

- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

## Optional Dependencies

- **Lottie-iOS**: For enhanced confetti animations
  - Add via: File > Add Package Dependencies > `https://github.com/airbnb/lottie-ios.git`
  - The app includes a graceful fallback if Lottie is not installed

## Setup

1. Clone the repository
2. Open `Runvent.xcodeproj` in Xcode
3. Build and run on iOS Simulator or device
4. (Optional) Add Lottie package dependency for enhanced animations
5. (Optional) Add `christmas_chime.mp3` (or .wav/.m4a) to the project for sound effects

## Testing

The project includes comprehensive test coverage:

- **Unit Tests**: ViewModel logic, persistence, and business rules
- **Snapshot Tests**: Visual verification of box states
- **Preview Tests**: SwiftUI preview-based testing

Run tests with: `Cmd + U` in Xcode

## License

This project is licensed under the **MIT License**.

See the `LICENSE` file for details.

## Author


**Houssem Farhani**

* GitHub: @TNxRebel (https://github.com/TNxRebel)
* Instagram: @houssemfarhani
