import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_sleep_database.dart';
import 'features/sleep_tracking/sleep_record_card.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/auth/auth_service.dart';
import 'features/sleep_tracking/add_sleep_data_dialog.dart';
import 'features/visualizations/sleep_graph.dart';
import 'features/reminders/reminders_page.dart';
import 'features/music/music_section.dart';

void main() async {
await Firebase.initializeApp(
  options: FirebaseOptions(
    apiKey: "",
    appId: "1:1234567890:web:abcdef123456",
    messagingSenderId: "1234567890",
    projectId: "no-code-etapa-3",
    authDomain: "no-code-etapa-3.firebaseapp.com",
    storageBucket: "no-code-etapa-3.appspot.com",
  ),
);
  runApp(const HypnosApp());
}

class HypnosApp extends StatelessWidget {
  const HypnosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hypnos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6EC6CA), // Calming teal
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6FBFB),
        fontFamily: 'Roboto',
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          titleMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      initialRoute: AuthService.instance.currentUser == null ? '/login' : '/home',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> sleepRecords = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchSleepRecords();
  }

  Future<void> _fetchSleepRecords() async {
    final records = await FirebaseSleepDatabase.getAllRecords();
    setState(() {
      sleepRecords = records;
      _loading = false;
    });
  }

  static Widget _buildSleepTracking(List<Map<String, dynamic>> records) {
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return SleepRecordCard(
          sleepTime: record['sleepTime'].toString(),
          wakeTime: record['wakeTime'].toString(),
          quality: record['quality'].toString(),
          notes: record['notes']?.toString() ?? '',
          date: record['date'] is DateTime ? record['date'] : DateTime.tryParse(record['date'].toString()) ?? DateTime.now(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      Stack(
        children: [
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _buildSleepTracking(sleepRecords),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AddSleepDataDialog(
                    onAdd: (data) async {
                      await FirebaseSleepDatabase.addRecord(data);
                      await _fetchSleepRecords();
                    },
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Data'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
      const SleepQualitySection(),
      const RemindersPage(),
      const MusicSection(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.nightlight_round, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Hypnos'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        elevation: 0,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bed), label: 'Track'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Quality'),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Reminders'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Music'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class SleepQualitySection extends StatelessWidget {
  const SleepQualitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sleep Quality',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to detailed sleep quality page
                },
                child: Text(
                  'View Details',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 0),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SleepGraph(),
          ),
        ),
      ],
    );
  }
}
