import 'package:shared_preferences/shared_preferences.dart';
import '../data/questions_data.dart';

// ============================================
// Question Model
// ============================================

class Option {
  final String id;
  final String text;
  final bool isCorrect;
  final String? image; // Optional image asset path

  Option({
    required this.id,
    required this.text,
    required this.isCorrect,
    this.image,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'] as String,
      text: json['text'] as String,
      isCorrect: json['is_correct'] as bool,
      image: json['image'] as String?,
    );
  }
}

class Question {
  final int id;
  final int level;
  final String topic;
  final String questionText;
  final List<Option> options;
  final String explanation;
  final String? imageSuggestion;

  Question({
    required this.id,
    required this.level,
    required this.topic,
    required this.questionText,
    required this.options,
    required this.explanation,
    this.imageSuggestion,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      level: json['level'] as int,
      topic: json['topic'] as String,
      questionText: json['question_text'] as String,
      options: (json['options'] as List)
          .map((o) => Option.fromJson(o as Map<String, dynamic>))
          .toList(),
      explanation: json['explanation'] as String,
      imageSuggestion: json['image_suggestion'] as String?,
    );
  }

  Option get correctOption => options.firstWhere((o) => o.isCorrect);
}

// ============================================
// Level Manager - Handles Progress & Unlocking
// ============================================

class LevelManager {
  static const String _unlockedLevelKey = 'unlocked_level';
  static const String _levelHighScorePrefix = 'level_high_score_';
  static const String _sessionScorePrefix = 'session_score_';
  static const String _sessionCompletedPrefix = 'session_completed_';

  SharedPreferences? _prefs;

  // Singleton pattern
  static final LevelManager _instance = LevelManager._internal();
  factory LevelManager() => _instance;
  LevelManager._internal();

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============================================
  // Level Unlocking & High Score
  // ============================================

  // Get current unlocked level (1-5)
  int getUnlockedLevel() {
    return _prefs?.getInt(_unlockedLevelKey) ?? 1;
  }

  // Check if a specific level is unlocked
  bool isLevelUnlocked(int level) {
    return level <= getUnlockedLevel();
  }

  // Get HIGH SCORE for a specific level (best attempt ever)
  int getLevelScore(int level) {
    return _prefs?.getInt('$_levelHighScorePrefix$level') ?? 0;
  }

  // ============================================
  // Session Management (Current Attempt)
  // ============================================

  // Get current session score (this attempt)
  int getSessionScore(int level) {
    return _prefs?.getInt('$_sessionScorePrefix$level') ?? 0;
  }

  // Get completed question IDs for current session
  List<int> getCompletedQuestions(int level) {
    final String? stored =
        _prefs?.getString('$_sessionCompletedPrefix$level');
    if (stored == null || stored.isEmpty) return [];
    return stored.split(',').map((s) => int.parse(s)).toList();
  }

  // Start a new session (called when entering a level)
  Future<void> startLevelSession(int level) async {
    if (_prefs == null) await init();

    // Clear session data for this level
    await _prefs?.setInt('$_sessionScorePrefix$level', 0);
    await _prefs?.setString('$_sessionCompletedPrefix$level', '');
  }

  // Save a completed question in the current session
  Future<void> saveQuestionResult({
    required int level,
    required int questionId,
    required bool isCorrect,
  }) async {
    if (_prefs == null) await init();

    // Get current session's completed questions
    List<int> completed = getCompletedQuestions(level);

    // Check if question was already answered IN THIS SESSION
    bool wasAlreadyAnswered = completed.contains(questionId);

    // Add to session completed list if not already there
    if (!wasAlreadyAnswered) {
      completed.add(questionId);
      await _prefs?.setString(
        '$_sessionCompletedPrefix$level',
        completed.join(','),
      );

      // Update SESSION score if correct
      if (isCorrect) {
        int sessionScore = getSessionScore(level);
        await _prefs?.setInt('$_sessionScorePrefix$level', sessionScore + 1);
      }
    }
  }

  // Finish the level session and update high score
  Future<void> finishLevelSession(int level) async {
    if (_prefs == null) await init();

    int sessionScore = getSessionScore(level);
    int highScore = getLevelScore(level);

    // HIGH SCORE LOGIC: Only update if session score is better
    if (sessionScore > highScore) {
      await _prefs?.setInt('$_levelHighScorePrefix$level', sessionScore);

      // Check if next level should unlock
      if (sessionScore >= pointsToUnlock && level < 5) {
        await _unlockNextLevel(level);
      }
    }

    // Note: We DON'T clear session data here - it stays until next startLevelSession
    // This allows the level complete dialog to show the session score
  }

  // Unlock the next level (private helper)
  Future<void> _unlockNextLevel(int currentLevel) async {
    if (_prefs == null) await init();

    int nextLevel = currentLevel + 1;
    if (nextLevel <= 5 && nextLevel > getUnlockedLevel()) {
      await _prefs?.setInt(_unlockedLevelKey, nextLevel);
    }
  }

  // ============================================
  // Question & Progress Queries
  // ============================================

  // Get all questions for a specific level
  List<Question> getQuestionsForLevel(int level) {
    return rawQuestions
        .where((q) => q['level'] == level)
        .map((q) => Question.fromJson(q))
        .toList();
  }

  // Get next unanswered question for current session
  Question? getNextQuestion(int level) {
    List<int> completed = getCompletedQuestions(level);
    List<Question> levelQuestions = getQuestionsForLevel(level);

    for (var question in levelQuestions) {
      if (!completed.contains(question.id)) {
        return question;
      }
    }
    return null; // All questions answered in this session
  }

  // Check if level session is complete (all questions answered)
  bool isLevelComplete(int level) {
    List<int> completed = getCompletedQuestions(level);
    List<Question> levelQuestions = getQuestionsForLevel(level);
    return completed.length >= levelQuestions.length;
  }

  // Get progress for a level based on HIGH SCORE (0.0 to 1.0)
  double getLevelProgress(int level) {
    int highScore = getLevelScore(level);
    List<Question> levelQuestions = getQuestionsForLevel(level);
    if (levelQuestions.isEmpty) return 0.0;
    return highScore / levelQuestions.length;
  }

  // ============================================
  // Reset & Utility
  // ============================================

  // Reset all progress (for testing)
  Future<void> resetProgress() async {
    if (_prefs == null) await init();
    await _prefs?.clear();
  }

  // Reset a specific level (for retry button)
  Future<void> resetLevelProgress(int level) async {
    if (_prefs == null) await init();

    // Clear session data only (high score remains)
    await _prefs?.setInt('$_sessionScorePrefix$level', 0);
    await _prefs?.setString('$_sessionCompletedPrefix$level', '');
  }

  // Get avatar based on unlocked level
  String getAvatarAsset([int? level]) {
    int lvl = level ?? getUnlockedLevel();
    return 'assets/avatars/avatar_lvl$lvl.png';
  }
}
