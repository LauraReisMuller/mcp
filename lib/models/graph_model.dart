// Graph data model for Hypnos app
// Represents main entities and their relationships

class User {
  final String id;
  final String name;
  final List<SleepSession> sleepSessions;
  final List<Reminder> reminders;
  final List<SleepGoal> sleepGoals;
  final List<Insight> insights;

  User({
    required this.id,
    required this.name,
    this.sleepSessions = const [],
    this.reminders = const [],
    this.sleepGoals = const [],
    this.insights = const [],
  });
}

class SleepSession {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final SleepQuality? quality;

  SleepSession({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.quality,
  });
}

class SleepQuality {
  final String id;
  final int rating; // e.g., 1-5
  final String? notes;

  SleepQuality({
    required this.id,
    required this.rating,
    this.notes,
  });
}

class Reminder {
  final String id;
  final String message;
  final DateTime time;

  Reminder({
    required this.id,
    required this.message,
    required this.time,
  });
}

class SleepGoal {
  final String id;
  final Duration targetDuration;
  final String? description;

  SleepGoal({
    required this.id,
    required this.targetDuration,
    this.description,
  });
}

class Insight {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  Insight({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });
}
// Mock data for testing and development
final mockSleepQuality = SleepQuality(
  id: 'sq1',
  rating: 4,
  notes: 'Felt rested, woke up once.',
);

final mockSleepSession = SleepSession(
  id: 'ss1',
  startTime: DateTime.now().subtract(Duration(hours: 8)),
  endTime: DateTime.now(),
  quality: mockSleepQuality,
);

final mockReminder = Reminder(
  id: 'r1',
  message: 'Go to bed by 10:30 PM',
  time: DateTime.now().add(Duration(hours: 12)),
);

final mockSleepGoal = SleepGoal(
  id: 'g1',
  targetDuration: Duration(hours: 8),
  description: 'Aim for 8 hours of sleep each night',
);

final mockInsight = Insight(
  id: 'i1',
  title: 'Consistent Bedtime',
  content: 'You sleep better when you go to bed at the same time.',
  createdAt: DateTime.now().subtract(Duration(days: 1)),
);

final mockUser = User(
  id: 'u1',
  name: 'Test User',
  sleepSessions: [mockSleepSession],
  reminders: [mockReminder],
  sleepGoals: [mockSleepGoal],
  insights: [mockInsight],
);
