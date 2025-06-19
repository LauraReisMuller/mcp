import 'package:flutter/material.dart';

class SleepRecordCard extends StatelessWidget {
  final String sleepTime;
  final String wakeTime;
  final String quality;
  final String notes;
  final DateTime date;

  const SleepRecordCard({
    super.key,
    required this.sleepTime,
    required this.wakeTime,
    required this.quality,
    required this.notes,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.bedtime, color: Theme.of(context).colorScheme.primary, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sleep: $sleepTime - Wake: $wakeTime',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text('Quality: $quality'),
                    ],
                  ),
                  if (notes.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text('Notes: $notes'),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${date.month}/${date.day}',
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
