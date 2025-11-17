# 🎄🏃 RunAdvent

### *A Christmas Advent Calendar for Runners — built with SwiftUI.*

This project is a cool but tough challenge for runners.
Most Advent calendars give you chocolate or small gifts, but this one gives you a daily running mission.

Each day, you open a “box” and get a random distance between 1 km and 24 km.
You never know what you’ll get: could be an easy 3 km, or suddenly a 20+ km push.

This randomness makes the challenge more fun and avoids overloading the runner.
Instead of stacking huge distances in the final week (like the traditional 1–24 km progression that ends with ~150 km in 7 days), the difficulty is spread more evenly across the whole month.

You’ll still end up with around 300 km total, but with a balanced distribution of tough and easy days.
A perfect mix of surprise, discipline, and endurance.

---

## ✨ Features

* 🎁 **24-Day Running Advent Calendar**
  Open one box per day and get a random distance between 1–24 km.

* 🎬 **Smooth SwiftUI Animations**
  Lid-lift, anticipation squash, pop-in reveal, glow effects, and optional confetti.

* 🎄 **Christmas Theme**
  Snowfall background, warm colors, and holiday UI styling.

* 💾 **Persistent State**
  Your opened days and generated kilometers are saved automatically.

* 📱 **Clean MVVM Architecture**
  Organized, scalable, and easy to understand.

* ⚙️ **Settings** *(optional)*
  Reset the calendar, enable/disable duplicates, toggle haptics & sound.

---

## 🧰 Tech Stack

* **Swift (iOS)**
* **SwiftUI**
* **MVVM**
* **Lottie** (optional confetti animation)
* **UserDefaults** (persistence)

---

## 🧱 Project Structure

```
Runvent/
│
├── Models/
│   └── AdventDay.swift
│
├── ViewModels/
│   └── RunventViewModel.swift
│
├── Views/
│   ├── HomeView.swift
│   ├── BoxView.swift
│   └── SettingsView.swift
│
├── Animations/
│   └── LottieView.swift
│
├── Utils/
│   └── Persistence.swift
│
└── Assets/
    └── confetti.json
```

---

## 🚀 Getting Started

Clone the repository:

```bash
git clone https://github.com/TNxRebel/Runvent.git
```

Open the project:

```bash
open Runvent.xcodeproj
```

Run on iOS 17+ using Xcode.

---

## 🍪 Roadmap

* [ ] Home Screen widget
* [ ] iCloud sync
* [ ] Daily share card
* [ ] Accessibility improvements

---

## 📝 License

This project is licensed under the **MIT License**.
See the `LICENSE` file for details.

---

## ✨ Author

**Houssem Farhani**

* GitHub: @TNxRebel (https://github.com/TNxRebel)
* Instagram: @houssemfarhani
