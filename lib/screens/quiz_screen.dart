import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';
import '../data/questions_data.dart';
import '../main.dart';
import 'triumph_dialog.dart';
import 'review_screen.dart';

class QuizScreen extends StatefulWidget {
  final int level;

  const QuizScreen({super.key, required this.level});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final LevelManager _levelManager = LevelManager();

  Question? _currentQuestion;
  int _questionIndex = 0;
  List<Question> _questions = [];
  bool _isLoading = true;
  int _sessionScore = 0;
  int _currentStreak = 0;

  // Answer state
  String? _selectedOptionId;
  bool? _isCorrectAnswer;
  bool _hasAnswered = false;

  Future<bool> _confirmExit() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: KidniColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.exit_to_app_rounded,
                  color: KidniColors.primary, size: 26),
              const SizedBox(width: 12),
              const Text('לצאת מהמשחק?'),
            ],
          ),
          content: const Text(
            'ההתקדמות בשלב זה לא תישמר.',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'להמשיך לשחק',
                style: TextStyle(color: _getLevelColor(widget.level)),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: KidniColors.errorDark,
              ),
              child: const Text('צא'),
            ),
          ],
        ),
      ),
    );
    return result ?? false;
  }

  @override
  void initState() {
    super.initState();
    _initLevel();
  }

  Future<void> _initLevel() async {
    // Start a fresh session for this level
    await _levelManager.startLevelSession(widget.level);

    // Load questions after session is cleared
    setState(() {
      _questions = _levelManager.getQuestionsForLevel(widget.level);

      // All questions start fresh - no completed ones
      if (_questions.isNotEmpty) {
        _questionIndex = 0;
        _currentQuestion = _questions[0];
      }

      _isLoading = false;
    });
  }

  Future<void> _onOptionSelected(Option option) async {
    if (_hasAnswered) return;

    setState(() {
      _selectedOptionId = option.id;
      _isCorrectAnswer = option.isCorrect;
      _hasAnswered = true;
      if (option.isCorrect) {
        _sessionScore++;
        _currentStreak++;
      } else {
        _currentStreak = 0;
      }
    });

    // Haptic feedback — tactile reward for kids
    if (option.isCorrect) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }

    // Save result and wait for it to persist
    await _levelManager.saveQuestionResult(
      level: widget.level,
      questionId: _currentQuestion!.id,
      isCorrect: option.isCorrect,
    );

    if (!mounted) return;

    // Show explanation bottom sheet
    _showExplanationSheet(option.isCorrect);
  }

  void _showExplanationSheet(bool isCorrect) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ExplanationSheet(
        isCorrect: isCorrect,
        explanation: _currentQuestion!.explanation,
        onNextPressed: _goToNextQuestion,
        isLastQuestion: _questionIndex >= _questions.length - 1,
      ),
    );
  }

  void _goToNextQuestion() {
    Navigator.pop(context); // Close bottom sheet

    if (_questionIndex < _questions.length - 1) {
      setState(() {
        _questionIndex++;
        _currentQuestion = _questions[_questionIndex];
        _selectedOptionId = null;
        _isCorrectAnswer = null;
        _hasAnswered = false;
      });
    } else {
      _finishAndShowComplete();
    }
  }

  Future<void> _finishAndShowComplete() async {
    final result = await _levelManager.finishLevelSession(widget.level);
    if (!mounted) return;

    if (result.newLevelUnlocked) {
      _showTriumphDialog(result);
    } else {
      _showStandardCompleteDialog(result);
    }
  }

  void _showTriumphDialog(LevelSessionResult result) {
    int nextLevel = widget.level + 1;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TriumphDialog(
        currentLevel: widget.level,
        score: result.sessionScore,
        totalQuestions: _questions.length,
        nextLevel: nextLevel,
        nextLevelColor: _getLevelColor(nextLevel),
        onContinue: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showStandardCompleteDialog(LevelSessionResult result) {
    bool passed = result.sessionScore >= pointsToUnlock;
    bool isLastLevel = widget.level >= 5;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          scrollable: true,
          backgroundColor: KidniColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (passed ? KidniColors.success : KidniColors.primary)
                      .withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  passed ? Icons.emoji_events : Icons.star,
                  color: passed
                      ? KidniColors.successDark
                      : Colors.amber.shade700,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  passed && isLastLevel
                      ? 'כל הכבוד! סיימת הכל!'
                      : 'סיימת את השלב!',
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ענית נכון על ${result.sessionScore} מתוך ${_questions.length} שאלות',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),

              // New high score banner (uses OLD high score from before update)
              if (result.isNewHighScore)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: KidniColors.success.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.amber.shade700, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'שיא חדש!',
                        style: TextStyle(
                          color: KidniColors.successDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              else if (result.oldHighScore > result.sessionScore)
                Text(
                  'השיא שלך: ${result.oldHighScore}/${_questions.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: KidniColors.textSecondary,
                  ),
                ),

              const SizedBox(height: 16),

              // Info box: context-aware message
              if (passed && isLastLevel)
                // Level 5 passed — all levels done
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: KidniColors.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: KidniColors.successDark.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.celebration,
                          color: KidniColors.successDark),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'השלמת את כל השלבים! אתה מומחה לתזונה נכונה לכליות',
                          style: TextStyle(
                            color: KidniColors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else if (!passed)
                // Didn't pass — show requirement
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: KidniColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: KidniColors.primary.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: KidniColors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'צריך $pointsToUnlock תשובות נכונות כדי לפתוח את השלב הבא. נסו שוב!',
                          style: TextStyle(
                            color: KidniColors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          actions: [
            // Review questions button
            TextButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ReviewScreen(
                      level: widget.level,
                      levelColor: _getLevelColor(widget.level),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.menu_book_rounded,
                  size: 18, color: _getLevelColor(widget.level)),
              label: Text(
                'סקור',
                style: TextStyle(color: _getLevelColor(widget.level)),
              ),
            ),
            // Retry button — copy differs by pass/fail
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _retryLevel();
              },
              child: Text(
                passed ? 'שחק שוב' : 'נסה שוב',
                style: TextStyle(color: _getLevelColor(widget.level)),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: KidniColors.primary,
              ),
              child: const Text('תפריט'),
            ),
          ],
        ),
      ),
    );
  }

  void _retryLevel() {
    setState(() {
      _isLoading = true;
      _sessionScore = 0;
      _currentStreak = 0;
      _selectedOptionId = null;
      _isCorrectAnswer = null;
      _hasAnswered = false;
    });
    _initLevel();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while session is initializing
    if (_isLoading) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: KidniColors.background,
          appBar: AppBar(
            title: Text(levelTitles[widget.level] ?? 'שלב ${widget.level}'),
            centerTitle: true,
            backgroundColor: _getLevelColor(widget.level),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(_getLevelColor(widget.level)),
            ),
          ),
        ),
      );
    }

    // This should never happen now, but keep as safety net
    if (_currentQuestion == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('שאלון')),
        body: const Center(child: Text('אין שאלות זמינות')),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _confirmExit();
        if (shouldExit && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: KidniColors.background,
          appBar: AppBar(
            title: Text(levelTitles[widget.level] ?? 'שלב ${widget.level}'),
            centerTitle: true,
            backgroundColor: _getLevelColor(widget.level),
            foregroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_forward_rounded),
              tooltip: 'חזרה',
              onPressed: () async {
                final shouldExit = await _confirmExit();
                if (shouldExit && mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                _buildProgressBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildQuestionCard(),
                        const SizedBox(height: 24),
                        _buildOptionsSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      color: _getLevelColor(widget.level),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'שאלה ${_questionIndex + 1} מתוך ${_questions.length}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Row(
                children: [
                  // Streak chip (appears at 3+)
                  if (_currentStreak >= 3) ...[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade600,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_fire_department_rounded,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'רצף $_currentStreak',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  // Score chip with animation on change
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        '$_sessionScore נקודות',
                        key: ValueKey(_sessionScore),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (_questionIndex + 1) / _questions.length,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KidniColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Topic chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _getLevelColor(widget.level).withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _currentQuestion!.topic,
              style: TextStyle(
                fontSize: 13,
                color: _getLevelColor(widget.level),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Question image — responsive: caps at 30% of screen height
          LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = MediaQuery.of(context).size.height;
              final maxImageSide = screenHeight * 0.3;
              final imageSide = constraints.maxWidth < maxImageSide
                  ? constraints.maxWidth
                  : maxImageSide;
              return ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  width: imageSide,
                  height: imageSide,
                  child: Image.asset(
                    _currentQuestion!.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade100,
                        child: Center(
                          child: Icon(
                            Icons.restaurant_rounded,
                            color: Colors.grey.shade400,
                            size: 64,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 18),

          // Question text
          Text(
            _currentQuestion!.questionText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.4,
              color: KidniColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection() {
    return Column(
      children: _currentQuestion!.options.map((option) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _AnimatedOptionCard(
            option: option,
            isSelected: _selectedOptionId == option.id,
            isCorrectAnswer: _isCorrectAnswer,
            hasAnswered: _hasAnswered,
            levelColor: _getLevelColor(widget.level),
            onTap: () => _onOptionSelected(option),
          ),
        );
      }).toList(),
    );
  }

  Color _getLevelColor(int level) {
    switch (level) {
      case 1:
        return KidniColors.level1;
      case 2:
        return KidniColors.level2;
      case 3:
        return KidniColors.level3;
      case 4:
        return KidniColors.level4;
      case 5:
        return KidniColors.level5;
      default:
        return KidniColors.level1;
    }
  }

}

// ============================================
// Animated Option Card with Scale Effect
// ============================================

class _AnimatedOptionCard extends StatefulWidget {
  final Option option;
  final bool isSelected;
  final bool? isCorrectAnswer;
  final bool hasAnswered;
  final Color levelColor;
  final VoidCallback onTap;

  const _AnimatedOptionCard({
    required this.option,
    required this.isSelected,
    required this.isCorrectAnswer,
    required this.hasAnswered,
    required this.levelColor,
    required this.onTap,
  });

  @override
  State<_AnimatedOptionCard> createState() => _AnimatedOptionCardState();
}

class _AnimatedOptionCardState extends State<_AnimatedOptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.hasAnswered) return;
    _controller.forward();
  }

  void _handleTap() {
    if (widget.hasAnswered) return;
    // Fire action IMMEDIATELY — don't wait for animation
    widget.onTap();
    // Reverse animation plays async; doesn't block the tap
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Determine card state colors using KidniColors
    Color cardColor = KidniColors.cardBackground;
    Color borderColor = Colors.grey.shade200;
    Color textColor = KidniColors.textPrimary;
    IconData? resultIcon;
    List<BoxShadow> shadows = [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 12,
        spreadRadius: 0,
        offset: const Offset(0, 4),
      ),
    ];

    if (widget.hasAnswered) {
      if (widget.isSelected) {
        if (widget.isCorrectAnswer!) {
          cardColor = KidniColors.success.withOpacity(0.25);
          borderColor = KidniColors.successDark;
          textColor = KidniColors.successDark;
          resultIcon = Icons.check_circle;
          shadows = [
            BoxShadow(
              color: KidniColors.successDark.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ];
        } else {
          cardColor = KidniColors.error.withOpacity(0.25);
          borderColor = KidniColors.errorDark;
          textColor = KidniColors.errorDark;
          resultIcon = Icons.cancel;
          shadows = [
            BoxShadow(
              color: KidniColors.errorDark.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ];
        }
      } else if (widget.option.isCorrect) {
        cardColor = KidniColors.success.withOpacity(0.2);
        borderColor = KidniColors.successDark.withOpacity(0.6);
        textColor = KidniColors.successDark;
        resultIcon = Icons.check_circle_outline;
      }
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTap: _handleTap,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 2.5),
            boxShadow: shadows,
          ),
          child: Row(
            children: [
              // Option letter badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.hasAnswered
                      ? borderColor.withOpacity(0.2)
                      : widget.levelColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.option.id,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          widget.hasAnswered ? textColor : widget.levelColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Option text
              Expanded(
                child: Text(
                  widget.option.text,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    height: 1.3,
                  ),
                ),
              ),

              // Result icon
              if (resultIcon != null)
                Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(resultIcon, color: borderColor, size: 30),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// Explanation Bottom Sheet
// ============================================

class _ExplanationSheet extends StatelessWidget {
  final bool isCorrect;
  final String explanation;
  final VoidCallback onNextPressed;
  final bool isLastQuestion;

  const _ExplanationSheet({
    required this.isCorrect,
    required this.explanation,
    required this.onNextPressed,
    required this.isLastQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: KidniColors.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 25,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 24),

                // Result header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? KidniColors.success.withOpacity(0.3)
                            : KidniColors.error.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect
                            ? KidniColors.successDark
                            : KidniColors.errorDark,
                        size: 36,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCorrect ? 'כל הכבוד!' : 'לא נורא!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isCorrect
                                  ? KidniColors.successDark
                                  : KidniColors.errorDark,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isCorrect
                                ? 'תשובה נכונה! +1 נקודה'
                                : 'בפעם הבאה יהיה יותר טוב',
                            style: TextStyle(
                              fontSize: 15,
                              color: KidniColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Explanation card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.amber.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_rounded,
                            color: Colors.amber.shade700,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'הסבר',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        explanation,
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.6,
                          color: KidniColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Next button
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: FilledButton.icon(
                    onPressed: onNextPressed,
                    icon: Icon(
                      isLastQuestion ? Icons.flag_rounded : Icons.arrow_back,
                      size: 22,
                    ),
                    label: Text(
                      isLastQuestion ? 'סיים שלב' : 'שאלה הבאה',
                      style: const TextStyle(fontSize: 18),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: isCorrect
                          ? KidniColors.successDark
                          : KidniColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
