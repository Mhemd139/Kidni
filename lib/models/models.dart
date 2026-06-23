import 'package:shared_preferences/shared_preferences.dart';
import '../data/questions_data.dart';
import '../data/questions_ar.dart';
import '../i18n/language.dart';

bool get _isArabic => LanguageController.instance.lang.value == AppLang.ar;

// ============================================
// Question Model
// ============================================

class Option {
  final String id;
  final String textHe;
  final String? textAr;
  final bool isCorrect;

  Option({
    required this.id,
    required this.textHe,
    required this.textAr,
    required this.isCorrect,
  });

  // Resolves to Arabic when selected and available, otherwise Hebrew.
  String get text => (_isArabic && textAr != null && textAr!.isNotEmpty)
      ? textAr!
      : textHe;

  factory Option.fromJson(Map<String, dynamic> json, String? arText) {
    return Option(
      id: json['id'] as String,
      textHe: json['text'] as String,
      textAr: arText,
      isCorrect: json['is_correct'] as bool,
    );
  }
}

class Question {
  final int id;
  final int level;
  final String topicHe;
  final String? topicAr;
  final String questionTextHe;
  final String? questionTextAr;
  final String image;
  final List<Option> options;
  final String explanationHe;
  final String? explanationAr;

  Question({
    required this.id,
    required this.level,
    required this.topicHe,
    required this.topicAr,
    required this.questionTextHe,
    required this.questionTextAr,
    required this.image,
    required this.options,
    required this.explanationHe,
    required this.explanationAr,
  });

  String _pick(String he, String? ar) =>
      (_isArabic && ar != null && ar.isNotEmpty) ? ar : he;

  String get topic => _pick(topicHe, topicAr);
  String get questionText => _pick(questionTextHe, questionTextAr);
  String get explanation => _pick(explanationHe, explanationAr);

  factory Question.fromJson(Map<String, dynamic> json) {
    final int id = json['id'] as int;
    final Map<String, dynamic>? ar = questionsAr[id];
    final Map<String, dynamic>? arOptions =
        ar?['options'] as Map<String, dynamic>?;

    return Question(
      id: id,
      level: json['level'] as int,
      topicHe: json['topic'] as String,
      topicAr: ar?['topic'] as String?,
      questionTextHe: json['question_text'] as String,
      questionTextAr: ar?['question'] as String?,
      image: json['image'] as String,
      options: (json['options'] as List).map((o) {
        final opt = o as Map<String, dynamic>;
        final String optId = opt['id'] as String;
        return Option.fromJson(opt, arOptions?[optId] as String?);
      }).toList(),
      explanationHe: json['explanation'] as String,
      explanationAr: ar?['explanation'] as String?,
    );
  }

  Option get correctOption => options.firstWhere((o) => o.isCorrect);
}

// ============================================
// Level Session Result
// ============================================

class LevelSessionResult {
  final int sessionScore;
  final int oldHighScore;
  final bool isNewHighScore;
  final bool newLevelUnlocked;

  LevelSessionResult({
    required this.sessionScore,
    required this.oldHighScore,
    required this.isNewHighScore,
    required this.newLevelUnlocked,
  });
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
  // Returns result with old/new scores and whether a new level was unlocked
  Future<LevelSessionResult> finishLevelSession(int level) async {
    if (_prefs == null) await init();

    int sessionScore = getSessionScore(level);
    int oldHighScore = getLevelScore(level);
    bool isNewHighScore = sessionScore > oldHighScore;
    bool newLevelUnlocked = false;

    if (isNewHighScore) {
      await _prefs?.setInt('$_levelHighScorePrefix$level', sessionScore);
    }

    // Check if next level should unlock (even if not a new high score,
    // the level might not have been unlocked yet)
    if (sessionScore >= pointsToUnlock && level < 5) {
      int nextLevel = level + 1;
      if (nextLevel > getUnlockedLevel()) {
        newLevelUnlocked = true;
        await _unlockNextLevel(level);
      }
    }

    return LevelSessionResult(
      sessionScore: sessionScore,
      oldHighScore: oldHighScore,
      isNewHighScore: isNewHighScore,
      newLevelUnlocked: newLevelUnlocked,
    );
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

  // Check if level has been passed (high score meets unlock threshold)
  bool isLevelComplete(int level) {
    return getLevelScore(level) >= pointsToUnlock;
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
