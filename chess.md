# ChessMaster Offline - Complete Development Blueprint

> **Version**: 1.0 MVP | **Platform**: Android (Flutter) | **Target Size**: 48-55 MB

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Feature Specifications](#feature-specifications)
3. [Technical Architecture](#technical-architecture)
4. [Project Structure](#project-structure)
5. [Database Schema](#database-schema)
6. [UI/UX Design](#uiux-design)
7. [Implementation Phases](#implementation-phases)
8. [Stockfish Integration](#stockfish-integration)
9. [Performance Optimizations](#performance-optimizations)
10. [Testing Strategy](#testing-strategy)

---

## 🎯 Project Overview

### App Identity
- **Name**: ChessMaster Offline
- **Target Size**: 48-55 MB
- **Platform**: Android (Flutter 3.x)
- **Timeline**: 3-4 months (solo) | 6-8 weeks (team)

### Tech Stack
| Component | Technology |
|-----------|------------|
| Frontend | Flutter 3.x (Dart) |
| Chess Logic | `dart_chess` package |
| Engine | Stockfish 16 NNUE (C++ via FFI) |
| Database | SQLite (`sqflite`) |
| State Management | Riverpod 2.x |
| UI Framework | Material Design 3 |
| Local Storage | `shared_preferences` + SQLite |

---

## ✅ Feature Specifications

### 1. Play vs Bot
| Feature | Priority | Status |
|---------|----------|--------|
| 10 difficulty levels (800-2800 ELO) | P0 | ⬜ |
| Custom ELO selection (800-3000) | P1 | ⬜ |
| Play as White/Black/Random | P0 | ⬜ |
| Resignation & draw offers | P1 | ⬜ |
| Move hints (max 3 per game) | P1 | ⬜ |
| Undo last move (unlimited) | P1 | ⬜ |
| Move history display | P0 | ⬜ |
| Legal move highlighting | P0 | ⬜ |
| Last move highlighting | P0 | ⬜ |
| Check/Checkmate/Stalemate detection | P0 | ⬜ |

### 2. Game Analysis
| Feature | Priority | Status |
|---------|----------|--------|
| Position evaluation bar (-10 to +10) | P0 | ⬜ |
| Best move suggestion | P0 | ⬜ |
| Top 3 engine lines (with depth) | P1 | ⬜ |
| Move-by-move analysis | P0 | ⬜ |
| Blunder/Mistake/Inaccuracy marking | P1 | ⬜ |
| Evaluation graph (full game) | P1 | ⬜ |
| Navigate through game moves | P0 | ⬜ |
| Analysis from custom FEN | P2 | ⬜ |

### 3. Timer System
| Feature | Priority | Status |
|---------|----------|--------|
| No timer option | P0 | ⬜ |
| Bullet: 1+0, 2+1 | P0 | ⬜ |
| Blitz: 3+0, 3+2, 5+0, 5+3 | P0 | ⬜ |
| Rapid: 10+0, 15+10 | P0 | ⬜ |
| Classical: 30+0, 30+20 | P1 | ⬜ |
| Custom timer configuration | P1 | ⬜ |
| Sound alerts (10 sec, time out) | P1 | ⬜ |
| Pause functionality (bot only) | P2 | ⬜ |

### 4. Game Management
| Feature | Priority | Status |
|---------|----------|--------|
| Save unlimited games locally | P0 | ⬜ |
| Auto-save on exit | P0 | ⬜ |
| Manual save with custom name | P1 | ⬜ |
| Load saved games | P0 | ⬜ |
| Continue from saved position | P0 | ⬜ |
| Delete games | P0 | ⬜ |
| Game history list | P0 | ⬜ |
| Search games by date/result | P2 | ⬜ |

### 5. PGN Features
| Feature | Priority | Status |
|---------|----------|--------|
| Import game from PGN text | P1 | ⬜ |
| Export game to PGN | P1 | ⬜ |
| Copy PGN to clipboard | P1 | ⬜ |
| Share PGN via share sheet | P1 | ⬜ |
| PGN validation & error reporting | P2 | ⬜ |

### 6. Position Setup
| Feature | Priority | Status |
|---------|----------|--------|
| Setup custom position (FEN editor) | P1 | ⬜ |
| Clear board | P1 | ⬜ |
| Place/remove pieces | P1 | ⬜ |
| Set turn (white/black) | P1 | ⬜ |
| Set castling rights | P2 | ⬜ |
| Play from custom position | P1 | ⬜ |
| Analyze custom position | P1 | ⬜ |

### 7. Customization
| Feature | Priority | Status |
|---------|----------|--------|
| 3 board themes | P0 | ⬜ |
| 2 piece sets | P0 | ⬜ |
| Board orientation flip | P0 | ⬜ |
| Show coordinates toggle | P1 | ⬜ |
| Move animation speed | P2 | ⬜ |
| Sound effects toggle | P0 | ⬜ |
| Vibration on move toggle | P2 | ⬜ |

### 8. Puzzles (2,000 included)
| Feature | Priority | Status |
|---------|----------|--------|
| Tactical puzzles (800-2400 rated) | P0 | ⬜ |
| Categories: Pins, Forks, Skewers, Mate, Endgame | P0 | ⬜ |
| Puzzle rating system | P1 | ⬜ |
| Success/failure tracking | P0 | ⬜ |
| Hint system (show first move) | P1 | ⬜ |
| Skip puzzle option | P1 | ⬜ |
| Solution explanation | P2 | ⬜ |
| User puzzle rating tracker | P1 | ⬜ |

### 9. Statistics Dashboard
| Feature | Priority | Status |
|---------|----------|--------|
| Total games played | P0 | ⬜ |
| Win/Loss/Draw record | P0 | ⬜ |
| Average game length | P1 | ⬜ |
| Puzzles solved/attempted | P0 | ⬜ |
| Current puzzle rating | P1 | ⬜ |
| Accuracy percentage | P2 | ⬜ |
| Most played openings | P2 | ⬜ |

### 10. Google Drive Backup
| Feature | Priority | Status |
|---------|----------|--------|
| Export all data to Drive | P1 | ⬜ |
| Restore from Drive backup | P1 | ⬜ |
| Manual backup trigger | P1 | ⬜ |
| Timestamped backups | P2 | ⬜ |

### 11. Opening Book (Basic)
| Feature | Priority | Status |
|---------|----------|--------|
| Top 50 openings with names | P1 | ⬜ |
| Opening identification in review | P2 | ⬜ |
| Common responses during game | P2 | ⬜ |
| Opening win rate stats | P2 | ⬜ |

---

## 🏗️ Technical Architecture

### State Management Flow
```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   UI Layer  │────▶│   Providers  │────▶│  Services   │
│  (Screens)  │◀────│  (Riverpod)  │◀────│ (Business)  │
└─────────────┘     └──────────────┘     └─────────────┘
                           │                    │
                           ▼                    ▼
                    ┌──────────────┐     ┌─────────────┐
                    │    Models    │     │  Database   │
                    │   (Entities) │     │  (SQLite)   │
                    └──────────────┘     └─────────────┘
```

### Engine Communication
```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Flutter   │────▶│   Dart FFI   │────▶│  Stockfish  │
│   (Dart)    │◀────│   Bridge     │◀────│   (C++)     │
└─────────────┘     └──────────────┘     └─────────────┘
      │                                        │
      └──────────── UCI Protocol ──────────────┘
```

---

## 📁 Project Structure

```
chess_master/
├── lib/
│   ├── main.dart                    # App entry point
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart   # ELO levels, timer presets
│   │   │   ├── colors.dart          # Theme colors
│   │   │   └── strings.dart         # App strings
│   │   ├── utils/
│   │   │   ├── pgn_parser.dart      # PGN import/export
│   │   │   ├── fen_parser.dart      # FEN handling
│   │   │   └── helpers.dart         # Common utilities
│   │   ├── services/
│   │   │   ├── stockfish_service.dart  # Engine communication
│   │   │   ├── database_service.dart   # SQLite operations
│   │   │   ├── storage_service.dart    # SharedPreferences
│   │   │   ├── audio_service.dart      # Sound effects
│   │   │   └── drive_service.dart      # Google Drive API
│   │   └── theme/
│   │       ├── app_theme.dart       # Material theme config
│   │       └── board_themes.dart    # Chess board themes
│   │
│   ├── models/
│   │   ├── game_model.dart          # Game state entity
│   │   ├── puzzle_model.dart        # Puzzle data entity
│   │   ├── move_model.dart          # Chess move entity
│   │   ├── analysis_model.dart      # Engine analysis result
│   │   ├── settings_model.dart      # User preferences
│   │   └── statistics_model.dart    # User stats entity
│   │
│   ├── providers/
│   │   ├── game_provider.dart       # Game state management
│   │   ├── engine_provider.dart     # Stockfish interaction
│   │   ├── settings_provider.dart   # User preferences
│   │   ├── puzzle_provider.dart     # Puzzle logic
│   │   ├── timer_provider.dart      # Chess clock logic
│   │   └── statistics_provider.dart # Stats tracking
│   │
│   ├── screens/
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   └── widgets/
│   │   │       └── menu_button.dart
│   │   ├── game/
│   │   │   ├── game_screen.dart
│   │   │   └── widgets/
│   │   │       ├── chess_board.dart
│   │   │       ├── chess_piece.dart
│   │   │       ├── move_list.dart
│   │   │       ├── timer_widget.dart
│   │   │       ├── eval_bar.dart
│   │   │       └── game_controls.dart
│   │   ├── game_setup/
│   │   │   └── game_setup_screen.dart
│   │   ├── analysis/
│   │   │   ├── analysis_screen.dart
│   │   │   └── widgets/
│   │   │       ├── eval_graph.dart
│   │   │       └── engine_lines.dart
│   │   ├── puzzles/
│   │   │   ├── puzzle_screen.dart
│   │   │   └── widgets/
│   │   │       └── puzzle_info.dart
│   │   ├── history/
│   │   │   └── game_history_screen.dart
│   │   ├── position_setup/
│   │   │   └── position_setup_screen.dart
│   │   ├── settings/
│   │   │   └── settings_screen.dart
│   │   └── stats/
│   │       └── statistics_screen.dart
│   │
│   └── widgets/                     # Shared widgets
│       ├── custom_button.dart
│       ├── difficulty_selector.dart
│       ├── timer_config_dialog.dart
│       ├── pgn_import_dialog.dart
│       ├── confirmation_dialog.dart
│       └── loading_overlay.dart
│
├── assets/
│   ├── pieces/
│   │   ├── traditional/            # Traditional piece SVGs
│   │   │   ├── wK.svg, wQ.svg...
│   │   │   └── bK.svg, bQ.svg...
│   │   └── modern/                 # Modern piece SVGs
│   │       ├── wK.svg, wQ.svg...
│   │       └── bK.svg, bQ.svg...
│   ├── sounds/
│   │   ├── move.mp3
│   │   ├── capture.mp3
│   │   ├── check.mp3
│   │   ├── castle.mp3
│   │   ├── game_start.mp3
│   │   ├── game_end.mp3
│   │   └── low_time.mp3
│   ├── puzzles/
│   │   └── puzzles.db              # Pre-populated puzzle DB
│   └── openings/
│       └── openings.json           # Opening book data
│
├── android/
│   └── app/src/main/
│       └── jniLibs/                # Stockfish native binaries
│           ├── arm64-v8a/
│           │   └── libstockfish.so
│           └── armeabi-v7a/
│               └── libstockfish.so
│
├── test/                           # Unit & widget tests
├── integration_test/               # Integration tests
├── pubspec.yaml
└── README.md
```

---

## 🗄️ Database Schema

### SQLite Tables

```sql
-- =============================================
-- GAMES TABLE - Stores all played games
-- =============================================
CREATE TABLE games (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,                    -- Custom save name
    pgn TEXT NOT NULL,            -- Full PGN notation
    fen_start TEXT,               -- Starting position (if custom)
    result TEXT,                  -- '1-0', '0-1', '1/2-1/2', '*'
    player_color TEXT,            -- 'white' or 'black'
    bot_elo INTEGER,              -- Bot difficulty level
    time_control TEXT,            -- e.g., '5+3'
    created_at INTEGER,           -- Unix timestamp
    duration_seconds INTEGER,     -- Game duration
    move_count INTEGER,           -- Total moves
    is_saved BOOLEAN DEFAULT 0,   -- Manual save flag
    opening_name TEXT             -- Detected opening
);

CREATE INDEX idx_games_created ON games(created_at DESC);
CREATE INDEX idx_games_saved ON games(is_saved) WHERE is_saved = 1;

-- =============================================
-- ANALYSIS CACHE - Caches engine evaluations
-- =============================================
CREATE TABLE analysis_cache (
    fen TEXT PRIMARY KEY,
    evaluation REAL,              -- Centipawn evaluation
    best_move TEXT,               -- Best move in UCI format
    depth INTEGER,                -- Analysis depth
    lines TEXT,                   -- JSON: top 3 engine lines
    cached_at INTEGER             -- Cache timestamp
);

-- =============================================
-- PUZZLE PROGRESS - Tracks user puzzle attempts
-- =============================================
CREATE TABLE puzzle_progress (
    puzzle_id INTEGER PRIMARY KEY,
    attempts INTEGER DEFAULT 0,
    solved BOOLEAN DEFAULT 0,
    last_attempted INTEGER        -- Unix timestamp
);

-- =============================================
-- STATISTICS - Single row for user statistics
-- =============================================
CREATE TABLE statistics (
    id INTEGER PRIMARY KEY CHECK (id = 1),
    total_games INTEGER DEFAULT 0,
    wins INTEGER DEFAULT 0,
    losses INTEGER DEFAULT 0,
    draws INTEGER DEFAULT 0,
    puzzles_solved INTEGER DEFAULT 0,
    puzzles_attempted INTEGER DEFAULT 0,
    current_puzzle_rating INTEGER DEFAULT 1200,
    games_by_elo TEXT,            -- JSON: {800: {w:5,l:2,d:1},...}
    openings_played TEXT,         -- JSON: {opening_name: count}
    last_updated INTEGER
);

-- =============================================
-- PUZZLES - Pre-populated from Lichess database
-- =============================================
CREATE TABLE puzzles (
    id INTEGER PRIMARY KEY,
    fen TEXT NOT NULL,            -- Starting position
    moves TEXT NOT NULL,          -- Solution (UCI format)
    rating INTEGER,               -- Puzzle difficulty rating
    themes TEXT,                  -- Comma-separated themes
    popularity INTEGER            -- Lichess popularity score
);

CREATE INDEX idx_puzzles_rating ON puzzles(rating);
CREATE INDEX idx_puzzles_themes ON puzzles(themes);
```

---

## 🎨 UI/UX Design

### Screen Flow Diagram
```
                    ┌─────────────────┐
                    │  Splash Screen  │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
         ┌──────────│   Home Screen   │──────────┐
         │          └────────┬────────┘          │
         │                   │                   │
    ┌────▼────┐        ┌─────▼─────┐       ┌────▼────┐
    │ New Game│        │  Puzzles  │       │ Settings│
    │  Setup  │        │  Screen   │       │ Screen  │
    └────┬────┘        └───────────┘       └─────────┘
         │
    ┌────▼────┐
    │  Game   │──────▶ Game Over ──────▶ Analysis
    │ Screen  │        Dialog            Screen
    └─────────┘
```

### Color Palette

```dart
// Board Themes
class BoardThemes {
  // Classic Wood
  static const classicLight = Color(0xFFF0D9B5);
  static const classicDark = Color(0xFFB58863);
  
  // Modern Blue
  static const blueLight = Color(0xFFDEE3E6);
  static const blueDark = Color(0xFF8CA2AD);
  
  // Forest Green
  static const greenLight = Color(0xFFEEEED2);
  static const greenDark = Color(0xFF769656);
}

// App Theme Colors (Material 3)
class AppColors {
  static const primary = Color(0xFF1B5E20);      // Deep Green
  static const secondary = Color(0xFF8D6E63);    // Brown
  static const surface = Color(0xFF121212);      // Dark background
  static const error = Color(0xFFCF6679);        // Error red
  static const onPrimary = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFFE1E1E1);
}
```

### Key Screen Layouts

#### Home Screen
```
┌─────────────────────────────────────┐
│     ♔ ChessMaster Offline           │
├─────────────────────────────────────┤
│                                     │
│   ┌─────────────────────────────┐   │
│   │     🎮 New Game             │   │
│   └─────────────────────────────┘   │
│   ┌─────────────────────────────┐   │
│   │     ▶️ Continue Game         │   │
│   └─────────────────────────────┘   │
│   ┌─────────────────────────────┐   │
│   │     📚 Load Game            │   │
│   └─────────────────────────────┘   │
│   ┌─────────────────────────────┐   │
│   │     🧩 Puzzles              │   │
│   └─────────────────────────────┘   │
│   ┌─────────────────────────────┐   │
│   │     🔍 Analysis             │   │
│   └─────────────────────────────┘   │
│   ┌─────────────────────────────┐   │
│   │     📊 Statistics           │   │
│   └─────────────────────────────┘   │
│   ┌─────────────────────────────┐   │
│   │     ⚙️ Settings              │   │
│   └─────────────────────────────┘   │
│                                     │
│   Quick Start:                      │
│   [Level 3] [Level 5] [Level 7]     │
└─────────────────────────────────────┘
```

#### Game Screen
```
┌─────────────────────────────────────┐
│ ← Bot (1600)              ⏱️ 5:23   │
├─────────────────────────────────────┤
│ ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓   │
│ ┃  8  ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜          ┃   │
│ ┃  7  ♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟          ┃   │
│ ┃  6  · · · · · · · ·          ┃   │
│ ┃  5  · · · · · · · ·          ┃   │
│ ┃  4  · · · · ♙ · · ·          ┃   │
│ ┃  3  · · · · · · · ·          ┃   │
│ ┃  2  ♙ ♙ ♙ ♙ · ♙ ♙ ♙          ┃   │
│ ┃  1  ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖          ┃   │
│ ┃     a b c d e f g h          ┃   │
│ ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛   │
│                                     │
│ ⏱️ 5:00              You (White)    │
├─────────────────────────────────────┤
│ 1.e4 e5 2.Nf3 Nc6 3.Bb5...         │
├─────────────────────────────────────┤
│ [💡Hint] [↶Undo] [⚙️] [🏳️] [💾]     │
└─────────────────────────────────────┘
```

---

## 📅 Implementation Phases

### Phase 1: Foundation (Week 1-2)
- [ ] Project setup with Flutter 3.x
- [ ] Configure Riverpod for state management
- [ ] Implement `dart_chess` integration
- [ ] Create database service (SQLite)
- [ ] Design and implement app theme
- [ ] Create chess board widget (CustomPainter)
- [ ] Implement piece rendering (SVG)

### Phase 2: Core Gameplay (Week 3-4)
- [ ] Implement game provider (state machine)
- [ ] Add move validation and highlighting
- [ ] Create move history display
- [ ] Implement drag-and-drop for moves
- [ ] Add game over detection
- [ ] Create game setup screen
- [ ] Implement difficulty selection

### Phase 3: Stockfish Integration (Week 5-6)
- [ ] Set up FFI bridge for Stockfish
- [ ] Implement UCI protocol communication
- [ ] Create engine provider
- [ ] Map difficulty levels to engine depth
- [ ] Implement bot move generation
- [ ] Add artificial thinking delays
- [ ] Test all difficulty levels

### Phase 4: Timer System (Week 7)
- [ ] Create timer provider
- [ ] Implement countdown logic
- [ ] Add increment support
- [ ] Create timer widget
- [ ] Add time control presets
- [ ] Implement custom timer dialog
- [ ] Add low-time sound alerts

### Phase 5: Game Management (Week 8)
- [ ] Implement auto-save functionality
- [ ] Create saved games database
- [ ] Build game history screen
- [ ] Add load game functionality
- [ ] Implement continue game feature
- [ ] Add game deletion
- [ ] Create PGN import/export

### Phase 6: Analysis Features (Week 9-10)
- [ ] Create analysis screen
- [ ] Implement position evaluation bar
- [ ] Add best move suggestion
- [ ] Create engine lines display
- [ ] Implement move classification
- [ ] Build evaluation graph
- [ ] Add move navigation

### Phase 7: Puzzles (Week 11)
- [ ] Import Lichess puzzle database
- [ ] Create puzzle screen
- [ ] Implement puzzle selection logic
- [ ] Add hint system
- [ ] Create solution validation
- [ ] Implement user rating system
- [ ] Add puzzle progress tracking

### Phase 8: Polish & Extras (Week 12)
- [ ] Implement statistics dashboard
- [ ] Add customization options
- [ ] Create settings screen
- [ ] Implement Google Drive backup
- [ ] Add opening book recognition
- [ ] Performance optimization
- [ ] Bug fixes and testing

---

## 🔧 Stockfish Integration

### Difficulty Mapping

| Level | ELO | Depth | Think Time | Description |
|-------|-----|-------|------------|-------------|
| 1 | 800 | 1 | 500ms | Beginner |
| 2 | 1000 | 3 | 800ms | Novice |
| 3 | 1200 | 5 | 1000ms | Casual |
| 4 | 1400 | 8 | 1200ms | Intermediate |
| 5 | 1600 | 10 | 1500ms | Club Player |
| 6 | 1800 | 12 | 1500ms | Advanced |
| 7 | 2000 | 15 | 1800ms | Expert |
| 8 | 2200 | 18 | 2000ms | Master |
| 9 | 2400 | 20 | 2000ms | Grandmaster |
| 10 | 2800 | 22 | 2500ms | Maximum |

### UCI Commands Reference

```
uci                    # Initialize UCI mode
isready                # Check engine ready
setoption name X value Y   # Configure options
position fen <FEN>     # Set position
position startpos moves <moves>  # Position from moves
go depth <N>           # Search to depth N
go movetime <ms>       # Search for X milliseconds
stop                   # Stop analysis
quit                   # Exit engine
```

### Key Engine Options

```dart
// Recommended settings for mobile
send('setoption name Threads value 2');
send('setoption name Hash value 128');
send('setoption name UCI_LimitStrength value true');
send('setoption name UCI_Elo value $targetElo');
```

---

## ⚡ Performance Optimizations

### 1. Board Rendering
- Use `CustomPainter` for 60fps rendering
- Cache piece images in memory
- Implement `shouldRepaint` properly
- Use `RepaintBoundary` for isolation

### 2. Engine Communication
- Cache opening positions
- Limit analysis depth on lower-end devices
- Use async/await for non-blocking calls
- Implement timeout handling

### 3. Database Operations
- Use database indices for queries
- Batch insert operations
- Implement lazy loading for history
- Use prepared statements

### 4. Memory Management
- Dispose controllers properly
- Clear analysis cache periodically
- Limit move history in memory
- Use `const` constructors

---

## 🧪 Testing Strategy

### Unit Tests
- Chess logic (move validation)
- PGN/FEN parsing
- Timer calculations
- ELO rating changes

### Widget Tests
- Chess board rendering
- Move input handling
- Timer display
- Game controls

### Integration Tests
- Full game flow
- Engine communication
- Database operations
- State persistence

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.0
  
  # Chess Logic
  chess: ^0.8.0              # Chess rules & validation
  
  # Storage
  sqflite: ^2.3.0            # SQLite database
  shared_preferences: ^2.2.0  # Key-value storage
  path_provider: ^2.1.0       # File system paths
  
  # UI
  flutter_svg: ^2.0.7         # SVG piece rendering
  fl_chart: ^0.65.0           # Evaluation graphs
  
  # Utilities
  uuid: ^4.2.0                # Unique IDs
  intl: ^0.18.0               # Date formatting
  share_plus: ^7.2.0          # Share functionality
  
  # Google Drive
  google_sign_in: ^6.1.0
  googleapis: ^12.0.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  mockito: ^5.4.0
  integration_test:
    sdk: flutter
```

---

## 📝 Notes & Considerations

### Size Optimization
- Compress audio files (use AAC/OGG)
- Optimize SVG pieces
- Use NNUE-small variant of Stockfish
- Limit puzzle database to 2,000

### Accessibility
- Support screen readers
- Add haptic feedback
- High contrast mode for pieces
- Scalable text support

### Future Enhancements (v2.0)
- Online multiplayer
- Opening trainer
- Endgame tablebase
- Voice commands
- Wear OS companion

---

*Last Updated: January 2026*
*Document Version: 1.0*
