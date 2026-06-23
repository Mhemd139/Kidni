import 'package:flutter/material.dart';
import '../models/models.dart';
import '../main.dart';
import '../i18n/strings.dart';

// ============================================
// Triumph Dialog - Level Complete with Unlock
// ============================================

class TriumphDialog extends StatefulWidget {
  final int currentLevel;
  final int score;
  final int totalQuestions;
  final int nextLevel;
  final Color nextLevelColor;
  final VoidCallback onContinue;

  const TriumphDialog({
    super.key,
    required this.currentLevel,
    required this.score,
    required this.totalQuestions,
    required this.nextLevel,
    required this.nextLevelColor,
    required this.onContinue,
  });

  @override
  State<TriumphDialog> createState() => _TriumphDialogState();
}

class _TriumphDialogState extends State<TriumphDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: KidniColors.cardBackground,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: widget.nextLevelColor.withOpacity(0.3),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              // Celebration icon
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: KidniColors.success.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.celebration_rounded,
                  color: Colors.amber.shade700,
                  size: 48,
                ),
              ),

              const SizedBox(height: 20),

              // Success message
              Text(
                t.correctTitle,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: KidniColors.successDark,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                t.answeredCorrectly(widget.score, widget.totalQuestions),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: KidniColors.textSecondary,
                ),
              ),

              const SizedBox(height: 28),

              // Animated Avatar Unlock Section
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.nextLevelColor.withOpacity(0.2),
                        widget.nextLevelColor.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.nextLevelColor.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      // New Avatar
                      Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: widget.nextLevelColor,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.nextLevelColor.withOpacity(0.4),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            LevelManager().getAvatarAsset(widget.nextLevel),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: widget.nextLevelColor.withOpacity(0.2),
                                child: Icon(
                                  _getAvatarIcon(widget.nextLevel),
                                  size: 45,
                                  color: widget.nextLevelColor,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Unlocked message
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_open_rounded,
                            color: widget.nextLevelColor,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            t.unlockedRank,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: widget.nextLevelColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        t.avatarTitle(widget.nextLevel),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: KidniColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        t.levelUnlocked(widget.nextLevel),
                        style: TextStyle(
                          fontSize: 14,
                          color: KidniColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: widget.onContinue,
                  icon: const Icon(Icons.arrow_back, size: 22),
                  label: Text(
                    t.backToMenu,
                    style: const TextStyle(fontSize: 18),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.nextLevelColor,
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
