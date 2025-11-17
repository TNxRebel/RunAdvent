# Lottie Package Setup Instructions

To use the confetti animations in this app, you need to add the Lottie package dependency.

## Steps to Add Lottie Package:

1. Open the project in Xcode
2. Go to **File** > **Add Package Dependencies...**
3. Enter the package URL: `https://github.com/airbnb/lottie-ios.git`
4. Click **Add Package**
5. Select the **Lottie** product and click **Add Package**
6. Make sure it's added to the **Runvent** target

## Alternative: Using Swift Package Manager via Terminal

If you prefer command line:

```bash
# Navigate to your project directory
cd /Users/houssem/Desktop/Projects/Runvent

# Add package via xcodebuild (this will open Xcode to confirm)
# Or manually add it through Xcode's UI as described above
```

## Adding Confetti Animation File

After adding the Lottie package, you'll need to add a confetti animation JSON file:

1. Download a confetti Lottie animation from [LottieFiles](https://lottiefiles.com/) (search for "confetti")
2. Add the JSON file to your project:
   - Right-click on the `Runvent` folder in Xcode
   - Select **Add Files to "Runvent"...**
   - Choose your confetti.json file
   - Make sure "Copy items if needed" is checked
   - Make sure "Runvent" target is selected

The animation file should be named `confetti.json` to match the code in `GiftBoxView`.

## Note

If you don't have a confetti animation file yet, the app will still compile and run, but the confetti animation won't display (you'll see a warning in the console). The box opening animation will still work.

## Adding Christmas Chime Sound

The app includes a Christmas chime sound that plays when a box is opened. To add the sound file:

1. Find or create a short (0.4s) Christmas chime sound file
2. Name it `christmas_chime.mp3` (or `.wav` or `.m4a`)
3. Add it to your project:
   - Right-click on the `Runvent` folder in Xcode
   - Select **Add Files to "Runvent"...**
   - Choose your `christmas_chime.mp3` file
   - Make sure "Copy items if needed" is checked
   - Make sure "Runvent" target is selected

The sound file should be named `christmas_chime` with extension `.mp3`, `.wav`, or `.m4a`. If the file is not found, the app will still work but will print a warning in the console.

