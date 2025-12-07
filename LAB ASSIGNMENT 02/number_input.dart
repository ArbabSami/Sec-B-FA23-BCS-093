import 'package:flutter/material.dart';

class NumberInput extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final bool enabled;
  final ValueChanged<int> onChanged;

  const NumberInput({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Decrement Button
        SizedBox(
          width: 56,
          height: 56,
          child: OutlinedButton(
            onPressed: enabled && value > min
                ? () => onChanged(value - 1)
                : null,
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
            ),
            child: const Icon(Icons.remove, size: 28),
          ),
        ),
        const SizedBox(width: 16),

        // Number Display
        Container(
          width: 120,
          height: 72,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          child: Center(
            child: Text(
              '$value',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: enabled
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Increment Button
        SizedBox(
          width: 56,
          height: 56,
          child: OutlinedButton(
            onPressed: enabled && value < max
                ? () => onChanged(value + 1)
                : null,
            style: OutlinedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
            ),
            child: const Icon(Icons.add, size: 28),
          ),
        ),
      ],
    );
  }
}
