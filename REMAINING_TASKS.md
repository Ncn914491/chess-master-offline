# ChessMaster Offline - Remaining Tasks

## 🎯 High Priority Tasks

### Task 1: Fix Board Flipping in Regular Puzzle Screen
**File**: `lib/screens/puzzles/puzzle_screen.dart`  
**Line**: ~424  
**Issue**: Board flips after every move, making puzzles confusing  
**Fix**:
```dart
// FIND (around line 424):
final isFlipped = !state.isWhiteTurn;

// REPLACE WITH:
final puzzle = state.currentPuzzle;
final isFlipped = puzzle != null && puzzle.fen.contains(' b ');
```
**Estimated Time**: 5 minutes  
**Priority**: 🔴 CRITICAL

---

### Task 2: Update Puzzle Menu to Use Daily Puzzle Screen
**File**: `lib/screens/puzzles/puzzle_menu_screen.dart`  
**Issue**: Daily puzzle uses wrong screen  
**Fix**:
1. Add import at top:
```dart
import 'package:chess_master/screens/puzzles/daily_puzzle_screen.dart';
```

2. Update `_startPuzzles` method (around line 180):
```dart
void _startPuzzles(PuzzleMode mode) {
  final notifier = ref.read(puzzleProvider.notifier);
  
  // Configure based on mode
  switch (mode) {
    case PuzzleMode.daily:
      notifier.setModeConfig(mode: PuzzleFilterMode.daily);
      // Navigate to special daily puzzle screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DailyPuzzleScreen(),
        ),
      );
      return; // Don't continue to regular puzzle screen
      
    case PuzzleMode.adaptive:
      notifier.setModeConfig(mode: PuzzleFilterMode.adaptive);
      break;
    // ... rest of cases
  }

  // Navigate to regular puzzle screen for non-daily modes
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const PuzzleScreen()),
  );
}
```
**Estimated Time**: 10 minutes  
**Priority**: 🔴 CRITICAL

---

### Task 3: Add Auto-Play Solution to Regular Puzzle Screen
**File**: `lib/screens/puzzles/puzzle_screen.dart`  
**Issue**: Solution only shows in dialog, not interactive  
**Fix**:
1. Copy the `_AutoPlaySolutionScreen` class from `daily_puzzle_screen.dart` to `puzzle_screen.dart`
2. Update `_showSolutionDialog` method to navigate to auto-play screen:
```dart
void _showSolutionDialog(PuzzleGameState state) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => _AutoPlaySolutionScreen(
        puzzle: state.currentPuzzle!,
      ),
    ),
  );
}
```
**Estimated Time**: 15 minutes  
**Priority**: 🟡 HIGH

---

### Task 4: Verify Puzzle Provider Hint Logic
**File**: `lib/providers/puzzle_provider.dart`  
**Issue**: Need to ensure hints properly set from/to squares  
**Action**: Review and test the `showHint()` method  
**Expected Code**:
```dart
void showHint() {
  final puzzle = state.currentPuzzle;
  if (puzzle == null || state.currentMoveIndex >= puzzle.moves.length) return;
  
  final nextMove = puzzle.moves[state.currentMoveIndex];
  final from = nextMove.substring(0, 2);
  final to = nextMove.substring(2, 4);
  
  state = state.copyWith(
    showingHint: true,
    hintFromSquare: from,
    hintToSquare: to,
    hintsUsed: state.hintsUsed + 1,
  );
  
  // Auto-clear hint after 3 seconds
  Future.delayed(const Duration(seconds: 3), () {
    if (mounted) {
      state = state.copyWith(clearHint: true);
    }
  });
}
```
**Estimated Time**: 20 minutes  
**Priority**: 🟡 HIGH

---

## 🎨 Medium Priority Tasks

### Task 5: Improve Regular Puzzle Screen UI
**File**: `lib/screens/puzzles/puzzle_screen.dart`  
**Issues**:
- Basic layout, not professional grade
- No visual hierarchy
- Buttons need better styling
- Missing animations

**Improvements Needed**:
1. Add gradient header card (similar to daily puzzle)
2. Improve button styling with better colors and spacing
3. Add visual feedback for correct/incorrect moves
4. Better spacing and padding throughout
5. Add subtle animations for state changes

**Estimated Time**: 1-2 hours  
**Priority**: 🟠 MEDIUM

---

### Task 6: Enhance Hint Visualization
**File**: `lib/screens/game/widgets/chess_board.dart`  
**Issue**: Hints only highlight one square, no arrows  
**Enhancement**: Add arrow drawing from hint start to hint end

**Implementation**:
1. Add parameters to ChessBoard:
```dart
final String? hintFrom;
final String? hintTo;
```

2. Create arrow painter:
```dart
void _drawArrow(Canvas canvas, Size size, String from, String to, Color color) {
  final squareSize = size.width / 8;
  
  // Calculate positions
  final fromPos = _getSquareCenter(from, squareSize);
  final toPos = _getSquareCenter(to, squareSize);
  
  // Draw arrow line
  final paint = Paint()
    ..color = color.withValues(alpha: 0.7)
    ..strokeWidth = squareSize * 0.15
    ..strokeCap = StrokeCap.round;
  
  canvas.drawLine(fromPos, toPos, paint);
  
  // Draw arrowhead
  _drawArrowhead(canvas, fromPos, toPos, paint);
}
```

3. Update puzzle screens to pass hintFrom and hintTo

**Estimated Time**: 2-3 hours  
**Priority**: 🟠 MEDIUM

---

### Task 7: Add Move Animations in Puzzles
**File**: `lib/screens/puzzles/puzzle_screen.dart`  
**Enhancement**: Animate opponent moves smoothly  
**Implementation**:
- Use AnimatedPositioned for piece movement
- Add 300ms duration with easeOut curve
- Show piece sliding from start to end square

**Estimated Time**: 1 hour  
**Priority**: 🟠 MEDIUM

---

### Task 8: Add Sound Effects for Puzzle Moves
**Files**: 
- `lib/screens/puzzles/puzzle_screen.dart`
- `lib/screens/puzzles/daily_puzzle_screen.dart`

**Enhancement**: Play sounds for:
- Correct move (success sound)
- Incorrect move (error sound)
- Puzzle completion (victory sound)
- Hint used (notification sound)

**Implementation**:
```dart
// In tryMove method
if (isCorrect) {
  AudioService.instance.playSound('correct.mp3');
} else {
  AudioService.instance.playSound('incorrect.mp3');
}

// On puzzle completion
if (state.state == PuzzleState.completed) {
  AudioService.instance.playSound('victory.mp3');
}
```

**Estimated Time**: 30 minutes  
**Priority**: 🟠 MEDIUM

---

## 🔧 Low Priority Tasks

### Task 9: Add Puzzle Statistics Screen
**New File**: `lib/screens/puzzles/puzzle_stats_screen.dart`  
**Feature**: Detailed statistics page showing:
- Rating history graph (line chart)
- Success rate by theme
- Streak information
- Best/worst themes
- Time spent on puzzles

**Estimated Time**: 3-4 hours  
**Priority**: 🟢 LOW

---

### Task 10: Implement Puzzle Themes Filtering
**File**: `lib/providers/puzzle_provider.dart`  
**Enhancement**: Better theme filtering logic  
**Current Issue**: Theme filtering is basic  
**Improvement**: 
- Support multiple theme selection
- Better theme matching algorithm
- Theme difficulty progression

**Estimated Time**: 2 hours  
**Priority**: 🟢 LOW

---

### Task 11: Add Puzzle Bookmarking
**Files**: 
- `lib/providers/puzzle_provider.dart`
- `lib/core/services/database_service.dart`

**Feature**: Allow users to bookmark difficult puzzles  
**Implementation**:
- Add bookmark button to puzzle screen
- Save bookmarked puzzles to database
- Create "Bookmarked Puzzles" section in menu
- Allow reviewing bookmarked puzzles later

**Estimated Time**: 2-3 hours  
**Priority**: 🟢 LOW

---

### Task 12: Add Puzzle Explanations
**File**: `lib/models/puzzle_model.dart`  
**Enhancement**: Add explanation field to puzzles  
**Feature**: Show tactical explanation after solving:
- "This was a fork tactic"
- "You exploited a pin"
- "Classic back rank mate pattern"

**Estimated Time**: 1 hour (+ content creation time)  
**Priority**: 🟢 LOW

---

## 🐛 Bug Fixes Needed

### Bug 1: Puzzle Rating Not Updating
**File**: `lib/providers/puzzle_provider.dart`  
**Issue**: User rating might not update after puzzle completion  
**Action**: Verify rating calculation and database save  
**Priority**: 🟡 HIGH

---

### Bug 2: Puzzle Queue Management
**File**: `lib/providers/puzzle_provider.dart`  
**Issue**: Puzzle queue might show duplicates  
**Action**: Implement better puzzle selection to avoid repeats  
**Priority**: 🟠 MEDIUM

---

### Bug 3: Promotion Dialog in Puzzles
**File**: `lib/screens/puzzles/puzzle_screen.dart`  
**Issue**: Promotion dialog might not appear correctly  
**Action**: Test pawn promotion in puzzles  
**Priority**: 🟠 MEDIUM

---

## 📋 Testing Tasks

### Test 1: Puzzle Flow Testing
**Actions**:
- [ ] Start daily puzzle
- [ ] Verify board doesn't flip
- [ ] Use hint - verify it highlights correct square
- [ ] Make incorrect move - verify error message
- [ ] Make correct moves - verify progression
- [ ] Complete puzzle - verify completion screen
- [ ] Check stats updated correctly

**Priority**: 🔴 CRITICAL

---

### Test 2: Regular Puzzle Testing
**Actions**:
- [ ] Start adaptive puzzle
- [ ] Test skip functionality
- [ ] Test retry functionality
- [ ] Test next puzzle functionality
- [ ] Verify rating changes
- [ ] Test different difficulty ranges

**Priority**: 🔴 CRITICAL

---

### Test 3: Edge Cases Testing
**Actions**:
- [ ] Test with no puzzles available
- [ ] Test with invalid FEN
- [ ] Test rapid hint clicking
- [ ] Test navigation during puzzle
- [ ] Test app backgrounding during puzzle

**Priority**: 🟡 HIGH

---

## 📊 Task Summary

### By Priority
- 🔴 **CRITICAL** (Must Do): 4 tasks
- 🟡 **HIGH** (Should Do): 4 tasks  
- 🟠 **MEDIUM** (Nice to Have): 4 tasks
- 🟢 **LOW** (Future Enhancement): 4 tasks

### By Estimated Time
- **Quick** (< 30 min): 4 tasks
- **Medium** (30 min - 2 hours): 6 tasks
- **Long** (2+ hours): 6 tasks

### By Category
- **Bug Fixes**: 3 tasks
- **UI Improvements**: 3 tasks
- **Features**: 5 tasks
- **Testing**: 3 tasks
- **Code Quality**: 2 tasks

---

## 🚀 Recommended Implementation Order

### Week 1 - Critical Fixes
1. Task 1: Fix board flipping (5 min)
2. Task 2: Update puzzle menu (10 min)
3. Test 1: Puzzle flow testing (30 min)
4. Task 3: Add auto-play solution (15 min)
5. Test 2: Regular puzzle testing (30 min)

**Total Time**: ~1.5 hours

### Week 2 - High Priority
6. Task 4: Verify hint logic (20 min)
7. Bug 1: Fix rating updates (1 hour)
8. Task 5: Improve puzzle UI (2 hours)
9. Test 3: Edge cases testing (1 hour)

**Total Time**: ~4.5 hours

### Week 3 - Medium Priority
10. Task 6: Enhance hint visualization (3 hours)
11. Task 7: Add move animations (1 hour)
12. Task 8: Add sound effects (30 min)
13. Bug 2 & 3: Fix remaining bugs (2 hours)

**Total Time**: ~6.5 hours

### Week 4 - Low Priority (Optional)
14. Tasks 9-12: Future enhancements (as time permits)

---

## ✅ Completion Checklist

### Phase 1: Critical (Must Complete)
- [ ] Board doesn't flip in puzzles
- [ ] Daily puzzle has separate UI
- [ ] Auto-play solution works
- [ ] All critical tests pass

### Phase 2: Polish (Should Complete)
- [ ] Hints show clearly
- [ ] UI looks professional
- [ ] Sound effects work
- [ ] All bugs fixed

### Phase 3: Enhancement (Nice to Have)
- [ ] Arrow hints implemented
- [ ] Statistics screen added
- [ ] Bookmarking works
- [ ] Explanations shown

---

## 📝 Notes

- All file paths are relative to project root
- Estimated times are for experienced Flutter developers
- Test on actual Android device after each phase
- Keep backup before making major changes
- Update this document as tasks are completed

---

**Last Updated**: Current Session  
**Status**: Ready for Implementation  
**Next Action**: Start with Task 1 (Fix board flipping)
