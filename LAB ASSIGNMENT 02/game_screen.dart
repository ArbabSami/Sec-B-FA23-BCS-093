import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/game_record.dart';
import '../database/database_helper.dart';
import '../widgets/number_input.dart';
import '../widgets/feedback_message.dart';
import '../widgets/attempts_counter.dart';
import '../widgets/stats_panel.dart';
import '../widgets/success_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int _targetNumber;
  late int _currentGuess;
  int _attempts = 0;
  FeedbackType _feedback = FeedbackType.none;
  bool _gameOver = false;
  late DateTime _gameStartTime;
  int _totalScore = 0;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadScore();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startNewGame();
    });
  }

  Future<void> _loadScore() async {
    final stats = await _dbHelper.getStats();
    setState(() {
      _totalScore = (stats['wins'] as int) * 100;
    });
  }

  void _startNewGame() {
    final provider = Provider.of<GameProvider>(context, listen: false);
    setState(() {
      _targetNumber = Random().nextInt(provider.maxNumber - provider.minNumber + 1) + provider.minNumber;
      _currentGuess = (provider.minNumber + provider.maxNumber) ~/ 2;
      _attempts = 0;
      _feedback = FeedbackType.none;
      _gameOver = false;
      _gameStartTime = DateTime.now();
    });
  }

  Future<void> _makeGuess() async {
    if (_gameOver) return;

    final provider = Provider.of<GameProvider>(context, listen: false);
    
    setState(() {
      _attempts++;
    });

    if (_currentGuess == _targetNumber) {
      setState(() {
        _feedback = FeedbackType.correct;
        _gameOver = true;
      });

      final timeTaken = DateTime.now().difference(_gameStartTime).inSeconds;
      final scoreGain = max(100 - (_attempts - 1) * 10, 10);
      
      await _dbHelper.insertRecord(GameRecord(
        date: DateTime.now(),
        won: true,
        attempts: _attempts,
        maxAttempts: provider.maxAttempts,
        timeTaken: timeTaken,
        targetNumber: _targetNumber,
      ));

      setState(() {
        _totalScore += scoreGain;
      });

      _showResultDialog(true);
    } else if (_attempts >= provider.maxAttempts) {
      setState(() {
        _feedback = FeedbackType.gameOver;
        _gameOver = true;
      });

      final timeTaken = DateTime.now().difference(_gameStartTime).inSeconds;
      
      await _dbHelper.insertRecord(GameRecord(
        date: DateTime.now(),
        won: false,
        attempts: _attempts,
        maxAttempts: provider.maxAttempts,
        timeTaken: timeTaken,
        targetNumber: _targetNumber,
      ));

      _showResultDialog(false);
    } else if (_currentGuess > _targetNumber) {
      setState(() {
        _feedback = FeedbackType.tooHigh;
      });
    } else {
      setState(() {
        _feedback = FeedbackType.tooLow;
      });
    }
  }

  void _showResultDialog(bool isWin) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        isWin: isWin,
        attempts: _attempts,
        targetNumber: _targetNumber,
        onPlayAgain: () {
          Navigator.pop(context);
          _startNewGame();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.tag,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Number Guess'),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  'Score: ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$_totalScore',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Range Display
            Text(
              'Guess a number between',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${provider.minNumber}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'and',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${provider.maxNumber}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Number Input
            NumberInput(
              value: _currentGuess,
              min: provider.minNumber,
              max: provider.maxNumber,
              enabled: !_gameOver,
              onChanged: (value) {
                setState(() {
                  _currentGuess = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Guess Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: _gameOver ? null : _makeGuess,
                child: const Text(
                  'Make a Guess',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Feedback Message
            FeedbackMessage(
              type: _feedback,
              targetNumber: _targetNumber,
            ),
            const SizedBox(height: 24),

            // Attempts Counter
            AttemptsCounter(
              remaining: provider.maxAttempts - _attempts,
              total: provider.maxAttempts,
            ),
            const SizedBox(height: 16),

            // New Game Button (when game over)
            if (_gameOver)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _startNewGame,
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Game'),
                ),
              ),
            const SizedBox(height: 32),

            // Stats Panel
            FutureBuilder<Map<String, dynamic>>(
              future: _dbHelper.getStats(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StatsPanel(
                    gamesPlayed: snapshot.data!['totalGames'] as int,
                    winRate: snapshot.data!['winRate'] as int,
                    bestScore: snapshot.data!['bestScore'] as int?,
                  );
                }
                return const StatsPanel(gamesPlayed: 0, winRate: 0, bestScore: null);
              },
            ),
          ],
        ),
      ),
    );
  }
}
