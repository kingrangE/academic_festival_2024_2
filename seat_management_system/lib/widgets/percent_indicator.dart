// lib/widgets/percent_indicator.dart
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PercentIndicator extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;

  const PercentIndicator({
    required this.label,
    required this.percent,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularPercentIndicator(
          radius: 50.0,
          lineWidth: 8.0,
          percent: percent,
          center: Text(
            '${(percent * 100).toInt()}%',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          progressColor: color,
          backgroundColor: Colors.white.withOpacity(0.3),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            color: color,
          ),
        ),
      ],
    );
  }
}
