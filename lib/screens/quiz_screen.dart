import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/questions_data.dart';
import '../main.dart';
import 'triumph_dialog.dart';

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

  // Answer state
  String? _selectedOptionId;
  bool? _isCorrectAnswer;
  bool _hasAnswered = false;

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

  void _onOptionSelected(Option option) {
    if (_hasAnswered) return;

    setState(() {
      _selectedOptionId = option.id;
      _isCorrectAnswer = option.isCorrect;
      _hasAnswered = true;
    });

    // Save result
    _levelManager.saveQuestionResult(
      level: widget.level,
      questionId: _currentQuestion!.id,
      isCorrect: option.isCorrect,
    );

    // Show explanation bottom sheet
    _showExplanationSheet(option.isCorrect);
  }

  void _showExplanationSheet(bool isCorrect) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
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
      _showLevelCompleteDialog();
    }
  }

  void _showLevelCompleteDialog() async {
    // Finish the session and update high score
    await _levelManager.finishLevelSession(widget.level);

    // Get SESSION score (what they just got)
    int sessionScore = _levelManager.getSessionScore(widget.level);
    int highScore = _levelManager.getLevelScore(widget.level);

    bool unlocked = widget.level < 5 && highScore >= pointsToUnlock;

    // Show triumph animation if this session passed and unlocked next level
    if (sessionScore >= pointsToUnlock && widget.level < 5) {
      _showTriumphDialog(sessionScore, highScore);
    } else {
      _showStandardCompleteDialog(sessionScore, highScore);
    }
  }

  void _showTriumphDialog(int sessionScore, int highScore) {
    int nextLevel = widget.level + 1;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TriumphDialog(
        currentLevel: widget.level,
        score: sessionScore,
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

  void _showStandardCompleteDialog(int sessionScore, int highScore) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: KidniColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: KidniColors.primary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.star,
                  color: Colors.amber.shade700,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Text('סיימת את השלב!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ענית נכון על $sessionScore מתוך ${_questions.length} שאלות',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              if (sessionScore > highScore)
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
              else if (highScore > sessionScore)
                Text(
                  'השיא שלך: $highScore/${_questions.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: KidniColors.textSecondary,
                  ),
                ),
              const SizedBox(height: 16),
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
                        'צריך $pointsToUnlock תשובות נכונות כדי לפתוח את השלב הבא',
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
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: KidniColors.primary,
              ),
              child: const Text('חזרה לתפריט'),
            ),
          ],
        ),
      ),
    );
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
        body: SafeArea(
          child: Column(
            children: [
              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildAvatarSection(),
                      const SizedBox(height: 20),
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_levelManager.getLevelScore(widget.level)} נקודות',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

  Widget _buildAvatarSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // Dynamic avatar image with breathing room
          Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: KidniColors.cardBackground,
              border: Border.all(
                color: _getLevelColor(widget.level),
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: _getLevelColor(widget.level).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                _levelManager.getAvatarAsset(widget.level),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if avatar image is missing
                  return Container(
                    color: _getLevelColor(widget.level).withOpacity(0.2),
                    child: Icon(
                      _getAvatarIcon(widget.level),
                      size: 45,
                      color: _getLevelColor(widget.level),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: _getLevelColor(widget.level).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getAvatarTitle(widget.level),
              style: TextStyle(
                fontSize: 14,
                color: _getLevelColor(widget.level),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
          const SizedBox(height: 20),
          Text(
            _currentQuestion!.questionText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
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

  IconData _getAvatarIcon(int level) {
    switch (level) {
      case 1:
        return Icons.child_care;
      case 2:
        return Icons.school;
      case 3:
        return Icons.psychology;
      case 4:
        return Icons.science;
      case 5:
        return Icons.medical_services;
      default:
        return Icons.child_care;
    }
  }

  String _getAvatarTitle(int level) {
    switch (level) {
      case 1:
        return 'מתחיל';
      case 2:
        return 'לומד';
      case 3:
        return 'מתקדם';
      case 4:
        return 'מומחה';
      case 5:
        return 'דוקטור';
      default:
        return 'מתחיל';
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
    if (!widget.hasAnswered) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.hasAnswered) {
      _controller.reverse().then((_) => widget.onTap());
    }
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
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
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
              // Option image
              if (widget.option.image != null)
                Container(
                  width: 75,
                  height: 75,
                  margin: const EdgeInsets.only(left: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: widget.hasAnswered
                          ? borderColor.withOpacity(0.5)
                          : widget.levelColor.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.option.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Friendly placeholder for missing food images
                        return Container(
                          color: Colors.grey.shade100,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.restaurant_rounded,
                                  color: Colors.grey.shade400,
                                  size: 32,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '?',
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              else
                // Fallback: Option letter badge when no image
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
          child: Padding(
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
