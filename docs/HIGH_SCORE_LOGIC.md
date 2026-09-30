# High Score Logic - Technical Documentation

## Problem Statement

**Bug Scenario:**
1. User plays Level 1, gets 1/4 correct → Fails
2. User retries Level 1, gets 4/4 correct → Wins
3. **Expected:** Score shows 4/4, Level 2 unlocks
4. **Previous Bug:** Score stayed at 1/4, ignored new attempt

## Solution: Session-Based High Score System

### Architecture Overview

The `LevelManager` now maintains **two separate tracking systems**:

1. **Session Score** (`session_score_X`) - Current attempt's score
2. **High Score** (`level_high_score_X`) - Best score ever achieved

### Key Concepts

#### Session Lifecycle

```
User enters level
    ↓
startLevelSession(level) → Clear session data
    ↓
User answers questions
    ↓
saveQuestionResult() → Track in session
    ↓
User completes all questions
    ↓
finishLevelSession(level) → Compare session vs high score
    ↓
Update high score if session > high score
    ↓
Check if next level should unlock
```

### API Methods

#### Session Management

```dart
// Called when QuizScreen.initState()
Future<void> startLevelSession(int level)
```
- Clears `session_score_X` to 0
- Clears `session_completed_X` to empty string
- **Does NOT affect high score** - previous best is preserved

```dart
// Called when last question is answered
Future<void> finishLevelSession(int level)
```
- Compares `sessionScore` vs `highScore`
- **IF** `sessionScore > highScore`:
  - Updates `level_high_score_X` with session score
  - Checks if should unlock next level (score >= 3)
- **ELSE**: Keeps old high score, does nothing
- Session data stays intact for dialog to display

#### Score Queries

```dart
int getLevelScore(int level)  // Returns HIGH SCORE (best ever)
int getSessionScore(int level) // Returns CURRENT attempt score
```

### SharedPreferences Keys

| Key | Purpose | Example Value | When Cleared |
|-----|---------|---------------|--------------|
| `unlocked_level` | Highest unlocked level | `3` | Only on resetProgress() |
| `level_high_score_1` | Best score for Level 1 | `4` | Only on resetProgress() |
| `session_score_1` | Current attempt score | `2` | On startLevelSession() |
| `session_completed_1` | Questions answered this session | `"1,2,3,4"` | On startLevelSession() |

## Implementation in quiz_screen.dart

### Initialization

```dart
@override
void initState() {
  super.initState();
  _initLevel();
}

Future<void> _initLevel() async {
  // Start fresh session - clears previous attempt
  await _levelManager.startLevelSession(widget.level);
  _loadQuestions();
}
```

### Level Completion

```dart
void _showLevelCompleteDialog() async {
  // Finish session and update high score
  await _levelManager.finishLevelSession(widget.level);

  // Get both scores
  int sessionScore = _levelManager.getSessionScore(widget.level);
  int highScore = _levelManager.getLevelScore(widget.level);

  // Show appropriate dialog
  if (sessionScore >= 3 && widget.level < 5) {
    _showTriumphDialog(sessionScore, highScore);
  } else {
    _showStandardCompleteDialog(sessionScore, highScore);
  }
}
```

### Dialog Display Logic

**Standard Complete Dialog:**
- Shows session score: "ענית נכון על X מתוך 4 שאלות"
- **IF** session > high score: Shows "שיא חדש!" badge
- **ELSE IF** high score > session: Shows "השיא שלך: X/4"
- Always shows unlock requirement: "צריך 3 תשובות נכונות..."

**Triumph Dialog:**
- Shows session score
- Shows newly unlocked avatar
- Displays next level information

## Test Scenarios

### Scenario 1: First Attempt Pass
1. User plays Level 1 for first time
2. Gets 3/4 correct
3. **Result:**
   - `session_score_1` = 3
   - `level_high_score_1` = 3 (new high score)
   - `unlocked_level` = 2 (unlocked)
   - Triumph dialog appears

### Scenario 2: Retry with Better Score
1. User played Level 1, got 1/4 (failed)
   - `level_high_score_1` = 1
2. User re-enters Level 1 → `startLevelSession(1)` clears session
3. User gets 4/4
4. **Result:**
   - `session_score_1` = 4
   - `level_high_score_1` = 4 (updated!)
   - `unlocked_level` = 2 (newly unlocked)
   - Shows "שיא חדש!" badge

### Scenario 3: Retry with Worse Score
1. User played Level 1, got 4/4 (passed)
   - `level_high_score_1` = 4
   - `unlocked_level` = 2
2. User re-enters Level 1 → `startLevelSession(1)` clears session
3. User gets 2/4
4. **Result:**
   - `session_score_1` = 2
   - `level_high_score_1` = 4 (unchanged!)
   - `unlocked_level` = 2 (stays unlocked)
   - Shows "השיא שלך: 4/4"

### Scenario 4: Retry with Same Score
1. User played Level 1, got 3/4
   - `level_high_score_1` = 3
2. User re-enters Level 1, gets 3/4 again
3. **Result:**
   - `session_score_1` = 3
   - `level_high_score_1` = 3 (unchanged, not > previous)
   - Shows completion dialog (no "new high score" badge)

## Edge Cases Handled

### ✅ Answering Same Question Twice in Session
- `saveQuestionResult()` checks `wasAlreadyAnswered`
- Only counts each question once per session
- Prevents score inflation

### ✅ Level Already Unlocked
- `_unlockNextLevel()` checks `nextLevel > getUnlockedLevel()`
- Prevents "re-locking" levels

### ✅ Session Score < Unlock Threshold but High Score >= Threshold
- User previously passed (Level 2 unlocked)
- Current attempt gets 1/4
- Level 2 stays unlocked (based on high score, not session)

### ✅ First Time Playing (No High Score)
- `getLevelScore()` returns 0 if no key exists
- Any session score > 0 becomes new high score

## Home Screen Integration

The home screen displays **high scores** (best ever), not session scores:

```dart
int score = _levelManager.getLevelScore(level);  // Uses high score
int totalQuestions = _levelManager.getQuestionsForLevel(level).length;

Text('$score/$totalQuestions תשובות נכונות')
```

Progress bar also uses high score:

```dart
double getLevelProgress(int level) {
  int highScore = getLevelScore(level);
  return highScore / totalQuestions;
}
```

## Migration Notes

**Breaking Change:** NO

The new keys (`level_high_score_X`, `session_score_X`) are separate from old `level_score_X`. If users have existing data:
- Old `level_score_X` will be ignored
- High scores start at 0 (clean slate)
- This is acceptable since it's a fresh session-based system

Alternatively, you could add migration logic in `init()`:

```dart
// Optional: Migrate old scores to new system
for (int level = 1; level <= 5; level++) {
  int? oldScore = _prefs?.getInt('level_score_$level');
  if (oldScore != null && getLevelScore(level) == 0) {
    await _prefs?.setInt('level_high_score_$level', oldScore);
  }
}
```

## Performance Considerations

- All operations use SharedPreferences (async I/O)
- `finishLevelSession()` uses async/await in dialog flow
- No performance impact - typical completion dialog delay acceptable
- Session clearing happens during level load (user doesn't notice)

## Future Enhancements

1. **Retry Button in Completion Dialog**
   ```dart
   TextButton(
     onPressed: () {
       Navigator.pop(context); // Close dialog
       Navigator.pushReplacement(
         context,
         MaterialPageRoute(
           builder: (context) => QuizScreen(level: widget.level),
         ),
       );
     },
     child: const Text('נסה שוב'),
   )
   ```

2. **Analytics Tracking**
   - Track number of attempts per level
   - Track improvement over time
   - Average score vs high score

3. **Leaderboard**
   - Store all attempts with timestamps
   - Show improvement graph

---

**Last Updated:** 2026-01-18
**Version:** 1.0.0 (High Score Implementation)
