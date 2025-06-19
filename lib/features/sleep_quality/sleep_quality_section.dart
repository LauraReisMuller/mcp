import '../visualizations/sleep_graph.dart';
import 'package:flutter/material.dart';

class SleepQualitySection extends StatelessWidget {
  const SleepQualitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Expanded(child: SleepGraph()),
      ],
    );
  }
}
