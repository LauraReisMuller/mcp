// A simple mock static database for Hypnos app
// This can be replaced with a real database or local storage in the future

class MockSleepDatabase {
  static final List<Map<String, dynamic>> sleepRecords = [
    {
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'sleepTime': '23:00',
      'wakeTime': '07:00',
      'quality': 4,
      'notes': 'Slept well, woke up once.'
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'sleepTime': '00:15',
      'wakeTime': '08:00',
      'quality': 3,
      'notes': 'Went to bed late, felt tired.'
    },
    {
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'sleepTime': '22:45',
      'wakeTime': '06:30',
      'quality': 5,
      'notes': 'Great sleep!'
    },
  ];

  static List<Map<String, dynamic>> getAllRecords() {
    return sleepRecords;
  }

  static void addRecord(Map<String, dynamic> record) {
    sleepRecords.insert(0, record);
  }
}
