import 'package:flutter/material.dart';

class AttemptsCounter extends StatelessWidget {
  final int remaining;
  final int total;

  const AttemptsCounter({
    super.key,
    required this.remaining,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = remaining / total;
    
    Color progressColor;
    if (percentage > 0.6) {
      progressColor = Theme.of(context).colorScheme.primary;
    } else if (percentage > 0.3) {
      progressColor = Colors.orange;
    } else {
      progressColor = Theme.of(context).colorScheme.error;
    }

    return Column(
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 6,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation(progressColor),
                ),
              ),
              Center(
                child: Text(
                  '$remaining',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: progressColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '$remaining of $total left',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: progressColor,
            ),
          ),
        ),
      ],
    );
  }
}
