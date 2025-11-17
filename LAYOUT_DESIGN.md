# RunAdvent Layout Design

## Overview

The Advent calendar uses a **6×6 grid system** where boxes can span multiple cells, creating a puzzle-like, playful layout that fills the entire screen.

## Grid System

- **Base Grid**: 6 columns × 6 rows
- **Spacing**: 6 points between boxes
- **Padding**: 8 points around the edges
- **Dynamic Sizing**: All boxes scale based on screen size
- **No Scrolling**: Everything fits on one screen

## Box Types

### Small (1×1)
Single cell boxes - compact and neat

### Wide (1×2 or 2×1)
Horizontal rectangles spanning 2 cells

### Tall (2×1)
Vertical rectangles spanning 2 rows

### Large (2×2)
Square boxes spanning 4 cells

## Layout Map

```
┌─────────────┬──────┬───────────┬──────┐
│             │      │           │      │
│    BOX 1    │ B 2  │   BOX 3   │      │
│   (2×2)     │      │   (1×2)   │ B 4  │
│             ├──────┼──────┬────┤      │
│             │ B 5  │ B 6  │    │(2×1) │
├──────┬──────┴──────┴──────┤ B 7│      │
│ B 8  │    BOX 9    │ B 10 │    │      │
│      │    (1×2)    │      ├────┼──────┤
├──────┼──────┬──────┴──────┤B 15│      │
│ B 12 │      │   BOX 14    │    │ B 16 │
│      │ B 13 │    (1×2)    ├────┤      │
├──────┤      ├──────┬──────┴────┤(2×1) │
│      │(2×1) │ B 18 │  BOX 19   │      │
│ B 17 │      │      │   (1×2)   ├──────┤
│      ├──────┼──────┼──────┬────┤ B 24 │
│(2×1) │ B 20 │ B 21 │ B 22 │B 23│      │
└──────┴──────┴──────┴──────┴────┴──────┘

B 11 = Box 11 (right side of grid)
```

## Box Placement Details

### Row 0-1 (Top Section)
- **Box 1**: (0,0) 2×2 - Large square, prominent start
- **Box 2**: (0,2) 1×1 - Small
- **Box 3**: (0,3) 1×2 - Wide horizontal
- **Box 4**: (0,5) 2×1 - Tall on right edge
- **Box 5**: (1,2) 1×1 - Small
- **Box 6**: (1,3) 1×1 - Small
- **Box 7**: (1,4) 2×1 - Tall

### Row 2 (Middle-Upper)
- **Box 8**: (2,0) 1×1 - Small left
- **Box 9**: (2,1) 1×2 - Wide
- **Box 10**: (2,3) 1×1 - Small
- **Box 11**: (2,5) 1×1 - Small right

### Row 3-4 (Middle-Lower)
- **Box 12**: (3,0) 1×1 - Small left
- **Box 13**: (3,1) 2×1 - Tall
- **Box 14**: (3,2) 1×2 - Wide
- **Box 15**: (3,4) 1×1 - Small
- **Box 16**: (3,5) 2×1 - Tall right
- **Box 17**: (4,0) 2×1 - Tall left
- **Box 18**: (4,2) 1×1 - Small
- **Box 19**: (4,3) 1×2 - Wide

### Row 5 (Bottom)
- **Box 20**: (5,1) 1×1 - Small
- **Box 21**: (5,2) 1×1 - Small
- **Box 22**: (5,3) 1×1 - Small
- **Box 23**: (5,4) 1×1 - Small
- **Box 24**: (5,5) 1×1 - Small (bottom-right corner)

## Features

✅ **Full Screen Coverage**: No empty spaces, entire screen is utilized
✅ **Balanced Distribution**: Mix of large and small boxes throughout
✅ **Aligned Borders**: All boxes align to the grid for clean appearance
✅ **Playful Arrangement**: Not uniform, creates visual interest
✅ **Responsive**: Automatically adapts to any iPhone screen size
✅ **No Scrolling**: Everything visible at once

## Visual Balance

- **Large Boxes** (2×2): 1 box (Box 1)
- **Tall Boxes** (2×1): 5 boxes (4, 7, 13, 16, 17)
- **Wide Boxes** (1×2): 4 boxes (3, 9, 14, 19)
- **Small Boxes** (1×1): 14 boxes (remaining)

This creates a nice pyramid effect with the large Box 1 at top-left, and various sized boxes cascading throughout.

## Technical Implementation

```swift
struct BoxGridItem {
    let dayNumber: Int   // 1-24
    let row: Int         // 0-5 (grid row)
    let col: Int         // 0-5 (grid column)
    let rowSpan: Int     // How many rows it spans
    let colSpan: Int     // How many columns it spans
}
```

Each box is calculated dynamically:
- Cell size = (screen size - spacing - padding) / 6
- Box width = (cellWidth × colSpan) + (spacing × (colSpan - 1))
- Box height = (cellHeight × rowSpan) + (spacing × (rowSpan - 1))

## Design Philosophy

The layout mimics a **real Advent calendar** with:
- Varying gift box sizes (just like real presents!)
- Playful, non-uniform arrangement
- Tetris-like puzzle aesthetic
- Professional alignment (everything snaps to grid)
- Maximum screen utilization
- Easy to navigate and tap any box

Perfect for the RunAdvent challenge! 🎄🏃

