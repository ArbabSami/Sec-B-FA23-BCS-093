import 'package:flutter/material.dart';

enum FeedbackType { none, tooHigh, tooLow, correct, gameOver }

class FeedbackMessage extends StatelessWidget {
  final FeedbackType type;
  final int targetNumber;

  const FeedbackMessage({
    super.key,
    required this.type,
    required this.targetNumber,
  });

  @override
  Widget build(BuildContext context) {
    if (type == FeedbackType.none) {
      return Container(
        height: 80,
        alignment: Alignment.center,
        child: Text(
          'Make your first guess!',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final config = _getConfig(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: config['bgColor'] as Color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(config['icon'] as IconData, color: config['iconColor'] as Color, size: 28),
              const SizedBox(width: 8),
              Text(
                config['text'] as String,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: config['textColor'] as Color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            config['subtext'] as String,
            style: TextStyle(
              fontSize: 14,
              color: (config['textColor'] as Color).withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getConfig(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    switch (type) {
      case FeedbackType.tooHigh:
        return {
          'icon': Icons.arrow_downward,
          'text': 'Too High!',
          'subtext': 'Try a lower number',
          'bgColor': isDark ? Colors.orange.shade900 : Colors.orange.shade100,
          'textColor': isDark ? Colors.orange.shade200 : Colors.orange.shade800,
          'iconColor': Colors.orange,
        };
      case FeedbackType.tooLow:
        return {
          'icon': Icons.arrow_upward,
          'text': 'Too Low!',
          'subtext': 'Try a higher number',
          'bgColor': isDark ? Colors.blue.shade900 : Colors.blue.shade100,
          'textColor': isDark ? Colors.blue.shade200 : Colors.blue.shade800,
          'iconColor': Colors.blue,
        };
      case FeedbackType.correct:
        return {
          'icon': Icons.check_circle,
          'text': 'Correct!',
          'subtext': 'You got it!',
          'bgColor': isDark ? Colors.green.shade900 : Colors.green.shade100,
          'textColor': isDark ? Colors.green.shade200 : Colors.green.shade800,
          'iconColor': Colors.green,
        };
      case FeedbackType.gameOver:
        return {
          'icon': Icons.close,
          'text': 'Game Over!',
          'subtext': 'The number was $targetNumber',
          'bgColor': isDark ? Colors.red.shade900 : Colors.red.shade100,
          'textColor': isDark ? Colors.red.shade200 : Colors.red.shade800,
          'iconColor': Colors.red,
        };
      default:
        return {};
    }
  }
}
