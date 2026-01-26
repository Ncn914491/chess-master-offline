# ChessMaster Offline - Major Overhaul Implementation Plan

## Overview

This document outlines the comprehensive changes required to address all identified issues and implement the new UI/UX structure based on user requirements.

---

## Issues Summary

### 1. **Game Start Issue** - Game not starting after clicking "Start Game"
- **Root Cause**: Need to verify engine initialization and game state management
- **Priority**: P0 (Critical)

### 2. **2-Player Offline Mode Missing**
- **Required**: Add "Play with Friend" option for 2 players on same device
- **Features**: Optional timer, takeback option, no hints
- **Priority**: P0 (Critical)

### 3. **Puzzle Hints Not Working**
- **Current Behavior**: Hint shows `fromSquare` only, not the full move with arrow
- **Required**: Show actual move arrow (from → to), add "Show Solution" button
- **Priority**: P1 (High)

### 4. **Remove Hint Limits for Puzzles**
- **Current**: 3 hints per puzzle with rating penalty
- **Required**: Unlimited hints (optional rating penalty)
- **Priority**: P1 (High)

### 5. **Analysis Screen - Missing PGN/Load Features**
- **Required**: Load PGN option, copy moves, metrics display
- **Priority**: P1 (High)

### 6. **Continue Game - Missing Load Options**
- **Required**: Load from saved games, load from PGN/FEN
- **Priority**: P1 (High)

### 7. **Load Game - Missing Save with PGN**
- **Required**: Export/save game with PGN format
- **Priority**: P2 (Medium)

### 8. **UI Restructure - Bottom Navigator + Sidebar**
- **New Structure**:
  - Bottom Navigation: Play, Puzzles, Analysis, Settings
  - Play Page: Bot options (levels 1-10 + Custom ELO), Play with Friend
  - Board flip option (disabled by default)
- **Priority**: P0 (Critical)

---

## New UI/UX Structure

### Bottom Navigation Bar (4 tabs)
```
┌─────────────────────────────────────────┐
│  [Play]  [Puzzles]  [Analysis]  [More]  │
└─────────────────────────────────────────┘
```

### Tab 1: Play Screen
```
┌─────────────────────────────────────────┐
│  ♔ Play Chess                            │
├─────────────────────────────────────────┤
│  🤖 Play with Bot                        │
│  ├── Standard Game                       │
│  │   ├── Level 1-10 (Progressive unlock) │
│  │   └── [Locked] until previous cleared │
│  └── Choose ELO (Custom 800-2800)        │
├─────────────────────────────────────────┤
│  👥 Play with Friend                     │
│  ├── Timer (optional)                    │
│  ├── Takeback (on/off)                   │
│  └── Board flip (disable by default)     │
├─────────────────────────────────────────┤
│  📂 Continue / Load Game                 │
│  ├── Resume last game                    │
│  ├── Saved games                         │
│  └── Load from PGN/FEN                   │
└─────────────────────────────────────────┘
```

### Tab 2: Puzzles Screen
```
┌─────────────────────────────────────────┐
│  🧩 Puzzle Trainer                       │
├─────────────────────────────────────────┤
│  [Adaptive Mode]                         │
│  [Random Puzzles]                        │
│  [Custom ELO Range]                      │
│  [By Theme]                              │
├─────────────────────────────────────────┤
│  Current Rating: 1200                    │
│  Solved: 45 | Attempted: 60              │
└─────────────────────────────────────────┘
```

### Tab 3: Analysis Screen
```
┌─────────────────────────────────────────┐
│  📊 Analysis Board                       │
├─────────────────────────────────────────┤
│  [Load PGN]  [Load FEN]  [Paste Moves]   │
├─────────────────────────────────────────┤
│  [New Position]                          │
│  [From Recent Games]                     │
├─────────────────────────────────────────┤
│  ⚙️ Engine Depth: 18                     │
│  📋 Copy FEN | Copy PGN                  │
└─────────────────────────────────────────┘
```

### Tab 4: More/Settings Screen
```
┌─────────────────────────────────────────┐
│  ⚙️ Settings & More                      │
├─────────────────────────────────────────┤
│  📊 Statistics                           │
│  🎨 Board Theme                          │
│  ♟️ Piece Set                            │
│  🔊 Sound Effects                        │
│  📍 Show Coordinates                     │
│  💾 Backup & Restore                     │
│  ℹ️ About                                │
└─────────────────────────────────────────┘
```

---

## Implementation Phases

### Phase 1: Fix Critical Game Issues (Day 1)
1. Debug and fix game start issue
2. Verify engine initialization flow
3. Test bot move triggering

### Phase 2: 2-Player Offline Mode (Day 1-2)
1. Create `LocalMultiplayerScreen`
2. Add game mode selection (Bot vs Local)
3. Implement:
   - Timer optional toggle
   - Takeback button
   - No hints in multiplayer
   - Board flip toggle (default: OFF)

### Phase 3: Fix Puzzle System (Day 2)
1. Fix hint display to show full move arrow
2. Add "Show Solution" button
3. Remove hint limit (or make optional)
4. Add solution animation

### Phase 4: Analysis Screen Enhancement (Day 2-3)
1. Add PGN load dialog
2. Add FEN paste input
3. Add "Copy moves" functionality
4. Add metrics display panel
5. Load from recent games list

### Phase 5: Continue/Load Game Enhancement (Day 3)
1. Create unified load game dialog
2. Add PGN import option
3. Add FEN paste option
4. Show preview before loading

### Phase 6: UI Restructure (Day 3-4)
1. Create new `MainScreen` with bottom navigation
2. Create dedicated `PlayScreen`
3. Move puzzles to dedicated tab
4. Move analysis to dedicated tab
5. Create `MoreScreen` for settings + stats
6. Implement progressive level unlock system

### Phase 7: Polish & Testing (Day 4)
1. Test all flows
2. Fix edge cases
3. UI polish
4. Performance optimization

---

## File Changes Required

### New Files to Create:
```
lib/
├── screens/
│   ├── main/
│   │   └── main_screen.dart           # Bottom nav container
│   ├── play/
│   │   ├── play_screen.dart           # Play tab main screen
│   │   ├── bot_options_screen.dart    # Bot difficulty selection
│   │   ├── local_multiplayer_screen.dart # 2-player game
│   │   └── load_game_dialog.dart      # Load from PGN/FEN/Saved
│   ├── puzzles/
│   │   └── puzzle_solution_dialog.dart # Show solution feature
│   ├── analysis/
│   │   └── load_analysis_dialog.dart  # Load PGN/FEN for analysis
│   └── more/
│       └── more_screen.dart           # Settings + Stats tab
├── providers/
│   └── local_game_provider.dart       # 2-player game state
└── models/
    └── level_progress_model.dart      # Track level unlocks
```

### Files to Modify:
```
lib/
├── main.dart                          # Change HomeScreen → MainScreen
├── screens/
│   ├── home/home_screen.dart          # Convert to play screen
│   ├── game/game_screen.dart          # Add 2-player mode support
│   ├── puzzles/puzzle_screen.dart     # Fix hints, add solution
│   └── analysis/analysis_screen.dart  # Add load/copy features
├── providers/
│   ├── game_provider.dart             # Add isLocalMultiplayer flag
│   └── puzzle_provider.dart           # Remove hint limit
└── core/
    └── constants/app_constants.dart   # Add game mode enum
```

---

## Detailed Changes

### 1. Game Start Fix
**File**: `lib/screens/home/home_screen.dart`
```dart
// Ensure engine is properly initialized before starting game
void _startGame() async {
  setState(() => _isLoading = true);
  try {
    final engineNotifier = widget.ref.read(engineProvider.notifier);
    await engineNotifier.initialize();  // Wait for initialization
    engineNotifier.resetForNewGame();
    
    // Start game AFTER engine is ready
    widget.ref.read(gameProvider.notifier).startNewGame(...);
    Navigator.push(...);
  } catch (e) {
    // Show error
  } finally {
    setState(() => _isLoading = false);
  }
}
```

### 2. 2-Player Local Mode
**File**: `lib/providers/game_provider.dart`
```dart
class GameState {
  // Add new field
  final GameMode gameMode; // bot, localMultiplayer
  
  bool get isLocalMultiplayer => gameMode == GameMode.localMultiplayer;
}
```

**File**: `lib/screens/play/local_multiplayer_screen.dart`
```dart
class LocalMultiplayerSettings {
  bool useTimer = false;
  TimeControl? timeControl;
  bool allowTakeback = true;
  bool autoFlipBoard = false;  // Default OFF
}
```

### 3. Puzzle Hint Fix
**File**: `lib/providers/puzzle_provider.dart`
```dart
void showHint() {
  // Current: only shows fromSquare
  // Fixed: show both from and to squares with arrow
  final expectedMove = puzzle.getExpectedMove(state.currentMoveIndex);
  final fromSquare = expectedMove.substring(0, 2);
  final toSquare = expectedMove.substring(2, 4);
  
  state = state.copyWith(
    hintFromSquare: fromSquare,
    hintToSquare: toSquare,    // ADD THIS
    showingHint: true,
    hintsUsed: state.hintsUsed + 1,
  );
}
```

**File**: `lib/screens/puzzles/puzzle_screen.dart`
Add "Show Solution" button:
```dart
ElevatedButton(
  onPressed: () => _showFullSolution(),
  child: Text('Show Solution'),
)

void _showFullSolution() {
  final puzzle = state.currentPuzzle;
  // Show dialog with all moves animated
}
```

### 4. Analysis Screen PGN Load
**File**: `lib/screens/analysis/analysis_screen.dart`
```dart
// Add to app bar actions
actions: [
  IconButton(
    icon: Icon(Icons.upload_file),
    onPressed: () => _showLoadPGNDialog(),
  ),
  IconButton(
    icon: Icon(Icons.copy),
    onPressed: () => _copyMovesToClipboard(),
  ),
]

void _showLoadPGNDialog() {
  showModalBottomSheet(
    child: Column(
      children: [
        TextField(hint: 'Paste PGN here...'),
        ElevatedButton(child: Text('Load')),
      ],
    ),
  );
}
```

### 5. Bottom Navigation Structure
**File**: `lib/screens/main/main_screen.dart`
```dart
class MainScreen extends ConsumerStatefulWidget {
  @override
  Widget build(context, ref) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          PlayScreen(),
          PuzzleMenuScreen(),
          AnalysisScreen(),
          MoreScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: 'Play'),
          BottomNavigationBarItem(icon: Icon(Icons.extension), label: 'Puzzles'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analysis'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
```

---

## Testing Checklist

- [ ] Game starts correctly after clicking "Start Game"
- [ ] Bot makes moves after player moves
- [ ] 2-player local mode works without engine
- [ ] Timer works in 2-player mode (when enabled)
- [ ] Takeback works in 2-player mode
- [ ] Board flip toggle works
- [ ] Puzzle hints show full move arrow
- [ ] "Show Solution" displays all moves
- [ ] Unlimited hints work in puzzles
- [ ] Analysis loads from PGN
- [ ] Analysis loads from FEN
- [ ] Copy moves works
- [ ] Continue game loads from saved games
- [ ] Load from PGN works
- [ ] Bottom navigation works correctly
- [ ] Level progression unlocks work
- [ ] All existing features still work

---

## Notes

1. **Board Flip**: Default to OFF to prevent confusion. User can enable in settings.
2. **Level Unlock**: Levels unlock sequentially by winning against previous level.
3. **Hints in Puzzles**: Keep rating penalty but remove limit count.
4. **Engine Initialization**: Must complete before any game starts.
5. **Local Multiplayer**: No engine needed, pure human vs human.

---

*Last Updated: January 2026*
