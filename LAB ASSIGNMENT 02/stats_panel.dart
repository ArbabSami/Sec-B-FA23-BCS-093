import 'package:flutter/material.dart';

class StatsPanel extends StatelessWidget {
  final int gamesPlayed;
  final int winRate;
  final int? bestScore;

  const StatsPanel({
    super.key,
    required this.gamesPlayed,
    required this.winRate,
    required this.bestScore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.sports_esports,
            iconColor: Colors.blue,
            value: '$gamesPlayed',
            label: 'Games',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.emoji_events,
            iconColor: Colors.amber,
            value: '$winRate%',
            label: 'Win Rate',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.flash_on,
            iconColor: Colors.green,
            value: bestScore != null ? '$bestScore' : '-',
            label: 'Best',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
