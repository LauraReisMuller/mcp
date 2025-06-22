import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../firebase_sleep_database.dart';
import 'package:intl/intl.dart';

class SleepGraph extends StatelessWidget {
  const SleepGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FirebaseSleepDatabase.getAllRecords(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final records = snapshot.data ?? [];
        if (records.isEmpty) {
          return const Center(child: Text('No sleep data to visualize.'));
        }
        // Prepare data for the graph
        final List<DateTime> dates = records.map((r) => r['date'] as DateTime).toList();
        final List<int> qualities = records.map((r) {
          final q = r['quality'];
          if (q is int) return q;
          if (q is String) return int.tryParse(q) ?? 1;
          return 1;
        }).toList();
        final double avgQuality = qualities.isNotEmpty
            ? qualities.reduce((a, b) => a + b) / qualities.length
            : 0;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.show_chart, color: Color(0xFF6EC6CA)),
                      SizedBox(width: 8),
                      Text('Sleep Quality', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Average Quality: ', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text(avgQuality.toStringAsFixed(1), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent)),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: CustomPaint(
                      painter: _SleepGraphPainter(dates: dates, qualities: qualities),
                      child: Container(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: dates.map((d) => Text(DateFormat('MM/dd').format(d), style: const TextStyle(fontSize: 13, color: Colors.grey))).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SleepGraphPainter extends CustomPainter {
  final List<DateTime> dates;
  final List<int> qualities;
  _SleepGraphPainter({required this.dates, required this.qualities});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6EC6CA)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    final pointPaint = Paint()
      ..color = Colors.deepPurpleAccent
      ..style = PaintingStyle.fill;
    final shadowPaint = Paint()
      ..color = const Color(0xFF6EC6CA).withOpacity(0.2)
      ..style = PaintingStyle.fill;
    final double minY = 1;
    final double maxY = 5;
    final double dx = size.width / (qualities.length - 1);
    final double graphHeight = size.height * 0.7;
    final double offsetY = size.height * 0.15;
    Path path = Path();
    Path shadowPath = Path();
    for (int i = 0; i < qualities.length; i++) {
      final x = i * dx;
      final y = offsetY + graphHeight * (1 - (qualities[i] - minY) / (maxY - minY));
      if (i == 0) {
        path.moveTo(x, y);
        shadowPath.moveTo(x, y);
      } else {
        path.lineTo(x, y);
        shadowPath.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 7, pointPaint);
      canvas.drawShadow(Path()..addOval(Rect.fromCircle(center: Offset(x, y), radius: 7)), Colors.black, 2, false);
    }
    // Fill under the curve for a soft area effect
    shadowPath.lineTo(size.width, size.height);
    shadowPath.lineTo(0, size.height);
    shadowPath.close();
    canvas.drawPath(shadowPath, shadowPaint);
    canvas.drawPath(path, paint);
    // Draw Y-axis labels (1-5)
    final textStyle = TextStyle(color: Colors.grey[600], fontSize: 12);
    for (int i = 1; i <= 5; i++) {
      final y = offsetY + graphHeight * (1 - (i - minY) / (maxY - minY));
      final tp = TextPainter(
        text: TextSpan(text: i.toString(), style: textStyle),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(-30, y - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
