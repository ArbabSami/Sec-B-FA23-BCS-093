class GameRecord {
  final int? id;
  final DateTime date;
  final bool won;
  final int attempts;
  final int maxAttempts;
  final int timeTaken;
  final int targetNumber;

  GameRecord({
    this.id,
    required this.date,
    required this.won,
    required this.attempts,
    required this.maxAttempts,
    required this.timeTaken,
    required this.targetNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'won': won ? 1 : 0,
      'attempts': attempts,
      'maxAttempts': maxAttempts,
      'timeTaken': timeTaken,
      'targetNumber': targetNumber,
    };
  }

  factory GameRecord.fromMap(Map<String, dynamic> map) {
    return GameRecord(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      won: (map['won'] as int) == 1,
      attempts: map['attempts'] as int,
      maxAttempts: map['maxAttempts'] as int,
      timeTaken: map['timeTaken'] as int,
      targetNumber: map['targetNumber'] as int,
    );
  }
}
