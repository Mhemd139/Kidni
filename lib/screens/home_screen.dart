import 'package:flutter/material.dart';
import '../models/models.dart';
import '../data/questions_data.dart';
import '../main.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LevelManager _levelManager = LevelManager();

  @override
  void initState() {
    super.initState();
    _initLevelManager();
  }

  Future<void> _initLevelManager() async {
    await _levelManager.init();
    setState(() {}); // Refresh after init
  }

  void _navigateToLevel(int level) {
    if (!_levelManager.isLevelUnlocked(level)) {
      _showLockedMessage(level);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(level: level),
      ),
    ).then((_) {
      // Refresh state when returning from quiz
      setState(() {});
    });
  }

  void _showLockedMessage(int level) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              const Icon(Icons.lock, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'צריך להשלים שלב ${level - 1} עם לפחות $pointsToUnlock תשובות נכונות כדי לפתוח שלב זה',
                ),
              ),
            ],
          ),
        ),
        backgroundColor: KidniColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
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
              Icon(Icons.favorite_rounded,
                  color: KidniColors.primary, size: 28),
              const SizedBox(width: 12),
              const Text('אודות קידני'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'קידני — לומדים לאכול נכון',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: KidniColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'אפליקציה חינוכית לילדים עם מחלת כליות כרונית ולהוריהם. ללמוד ביחד על בחירות מזון נכונות, טכניקות בישול ותוויות מזון.',
                style: TextStyle(
                  fontSize: 14,
                  color: KidniColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: KidniColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: KidniColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: KidniColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'המידע במשחק הוא לצורך למידה בלבד. תמיד התייעצו עם הרופא והדיאטנית של הילד.',
                        style: TextStyle(
                          fontSize: 12,
                          color: KidniColors.textPrimary,
                          height: 1.4,
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
              onPressed: () => Navigator.pop(context),
              child: const Text('סגור'),
            ),
          ],
        ),
      ),
    );
  }

  // Reset progress for testing
  Future<void> _resetProgress() async {
    final confirmed = await showDialog<bool>(
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
              Icon(Icons.warning_amber_rounded,
                  color: KidniColors.primary, size: 28),
              const SizedBox(width: 12),
              const Text('איפוס התקדמות'),
            ],
          ),
          content: const Text(
            'האם אתה בטוח שברצונך למחוק את כל ההתקדמות ולהתחיל מחדש?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'ביטול',
                style: TextStyle(color: KidniColors.textSecondary),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(
                backgroundColor: KidniColors.errorDark,
              ),
              child: const Text('אפס'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      await _levelManager.resetProgress();
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  Icon(Icons.refresh, color: Colors.white),
                  SizedBox(width: 12),
                  Text('ההתקדמות אופסה בהצלחה'),
                ],
              ),
            ),
            backgroundColor: KidniColors.successDark,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: KidniColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: KidniColors.textSecondary,
              ),
              tooltip: 'תפריט',
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              onSelected: (value) {
                switch (value) {
                  case 'about':
                    _showAboutDialog();
                    break;
                  case 'reset':
                    _resetProgress();
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'about',
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: KidniColors.primary, size: 20),
                      const SizedBox(width: 12),
                      const Text('אודות'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'reset',
                  child: Row(
                    children: [
                      Icon(Icons.refresh_rounded,
                          color: KidniColors.errorDark, size: 20),
                      const SizedBox(width: 12),
                      const Text('איפוס התקדמות'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Avatar display
              _buildAvatarSection(),

              const SizedBox(height: 16),

              // Levels list
              Expanded(
                child: _buildLevelsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        children: [
          // App title with gradient effect
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                KidniColors.primary,
                KidniColors.primaryDark,
              ],
            ).createShader(bounds),
            child: const Text(
              'קידני',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'לומדים לאכול נכון',
            style: TextStyle(
              fontSize: 17,
              color: KidniColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    int currentLevel = _levelManager.getUnlockedLevel();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getLevelColor(currentLevel),
            _getLevelColor(currentLevel).withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _getLevelColor(currentLevel).withOpacity(0.35),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with actual image
          Container(
            width: 75,
            height: 75,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                _levelManager.getAvatarAsset(currentLevel),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if avatar image is missing
                  return Container(
                    color: Colors.white.withOpacity(0.2),
                    child: Icon(
                      _getAvatarIcon(currentLevel),
                      size: 36,
                      color: _getLevelColor(currentLevel),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 18),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getAvatarTitle(currentLevel),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'שלב $currentLevel מתוך 5',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Progress circle
          _buildProgressCircle(currentLevel),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(int currentLevel) {
    int totalScore = 0;
    int maxScore = 0;

    for (int i = 1; i <= 5; i++) {
      totalScore += _levelManager.getLevelScore(i);
      maxScore += _levelManager.getQuestionsForLevel(i).length;
    }

    double progress = maxScore > 0 ? totalScore / maxScore : 0;

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 5,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelsList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      itemCount: 5,
      itemBuilder: (context, index) {
        int level = index + 1;
        return _buildLevelCard(level);
      },
    );
  }

  Widget _buildLevelCard(int level) {
    bool isUnlocked = _levelManager.isLevelUnlocked(level);
    bool isComplete = _levelManager.isLevelComplete(level);
    int score = _levelManager.getLevelScore(level);
    int totalQuestions = _levelManager.getQuestionsForLevel(level).length;
    double progress = _levelManager.getLevelProgress(level);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _navigateToLevel(level),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isUnlocked
                ? KidniColors.cardBackground
                : Colors.grey.shade100.withOpacity(0.7),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isUnlocked
                  ? _getLevelColor(level).withOpacity(0.35)
                  : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: isUnlocked
                ? [
                    BoxShadow(
                      color: _getLevelColor(level).withOpacity(0.12),
                      blurRadius: 15,
                      spreadRadius: 0,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Level number circle
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? _getLevelColor(level)
                        : Colors.grey.shade400,
                    shape: BoxShape.circle,
                    boxShadow: isUnlocked
                        ? [
                            BoxShadow(
                              color: _getLevelColor(level).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isUnlocked
                        ? Text(
                            '$level',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.lock_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                  ),
                ),

                const SizedBox(width: 16),

                // Level info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        levelTitles[level] ?? 'שלב $level',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked
                              ? KidniColors.textPrimary
                              : KidniColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (isUnlocked) ...[
                        Text(
                          '$score/$totalQuestions תשובות נכונות',
                          style: TextStyle(
                            fontSize: 13,
                            color: KidniColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor:
                                _getLevelColor(level).withOpacity(0.15),
                            valueColor: AlwaysStoppedAnimation(
                              _getLevelColor(level),
                            ),
                            minHeight: 7,
                          ),
                        ),
                      ] else
                        Text(
                          'נעול - השלם שלב ${level - 1} כדי לפתוח',
                          style: TextStyle(
                            fontSize: 13,
                            color: KidniColors.textLight,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Status icon
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isComplete
                        ? KidniColors.success.withOpacity(0.2)
                        : (isUnlocked
                            ? _getLevelColor(level).withOpacity(0.1)
                            : Colors.grey.shade200),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isComplete
                        ? Icons.check_circle_rounded
                        : (isUnlocked
                            ? Icons.play_circle_fill_rounded
                            : Icons.lock_rounded),
                    color: isComplete
                        ? KidniColors.successDark
                        : (isUnlocked
                            ? _getLevelColor(level)
                            : Colors.grey.shade400),
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
