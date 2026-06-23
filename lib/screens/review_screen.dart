import 'package:flutter/material.dart';
import '../models/models.dart';
import '../main.dart';
import '../i18n/strings.dart';

class ReviewScreen extends StatelessWidget {
  final int level;
  final Color levelColor;

  const ReviewScreen({
    super.key,
    required this.level,
    required this.levelColor,
  });

  @override
  Widget build(BuildContext context) {
    final questions = LevelManager().getQuestionsForLevel(level);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: KidniColors.background,
        appBar: AppBar(
          title: Text(t.reviewTitle(t.levelTitle(level))),
          centerTitle: true,
          backgroundColor: levelColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return _buildQuestionReview(questions[index], index + 1);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionReview(Question question, int number) {
    final correctOption = question.correctOption;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: KidniColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: levelColor.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question number badge
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: levelColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question.questionText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: KidniColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Question image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                question.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade100,
                  child: Center(
                    child: Icon(
                      Icons.restaurant_rounded,
                      color: Colors.grey.shade400,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Correct answer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: KidniColors.success.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: KidniColors.successDark.withOpacity(0.4),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_rounded,
                    color: KidniColors.successDark, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.correctAnswer,
                        style: TextStyle(
                          fontSize: 12,
                          color: KidniColors.successDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        correctOption.text,
                        style: TextStyle(
                          fontSize: 15,
                          color: KidniColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Explanation
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.amber.shade300,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_rounded,
                    color: Colors.amber.shade700, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    question.explanation,
                    style: TextStyle(
                      fontSize: 14,
                      color: KidniColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
