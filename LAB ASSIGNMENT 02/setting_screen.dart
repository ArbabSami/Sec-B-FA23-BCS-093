import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../database/database_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    final dbHelper = DatabaseHelper.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Game Settings Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Game Settings',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    // Number Range
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Number Range'),
                        Text('${provider.minNumber} - ${provider.maxNumber}'),
                      ],
                    ),
                    Slider(
                      value: provider.maxNumber.toDouble(),
                      min: 10,
                      max: 1000,
                      divisions: 99,
                      onChanged: (value) {
                        provider.updateSettings(maxNumber: value.toInt());
                      },
                    ),
                    const SizedBox(height: 16),

                    // Max Attempts
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Max Attempts'),
                        Text('${provider.maxAttempts}'),
                      ],
                    ),
                    Slider(
                      value: provider.maxAttempts.toDouble(),
                      min: 3,
                      max: 20,
                      divisions: 17,
                      onChanged: (value) {
                        provider.updateSettings(maxAttempts: value.toInt());
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Preferences Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Preferences',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Sound Effects'),
                      value: provider.soundEnabled,
                      onChanged: (value) {
                        provider.updateSettings(soundEnabled: value);
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    SwitchListTile(
                      title: const Text('Vibration'),
                      value: provider.vibrationEnabled,
                      onChanged: (value) {
                        provider.updateSettings(vibrationEnabled: value);
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Data Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Clear History'),
                              content: const Text(
                                'Are you sure you want to delete all game history? This action cannot be undone.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.error,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            await dbHelper.clearAllRecords();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('History cleared')),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Clear Game History'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
