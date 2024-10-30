// lib/widgets/animated_away_time_indicator.dart
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AnimatedAwayTimeIndicator extends StatefulWidget {
  final String label;
  final Duration awayTime;
  final Duration maxTime;
  final Color color;
  final Duration duration;

  const AnimatedAwayTimeIndicator({
    super.key,
    required this.label,
    required this.awayTime,
    required this.maxTime,
    required this.color,
    required this.duration,
  });

  @override
  State<AnimatedAwayTimeIndicator> createState() => _AnimatedAwayTimeIndicatorState();
}

class _AnimatedAwayTimeIndicatorState extends State<AnimatedAwayTimeIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    final percent = widget.awayTime.inMinutes / widget.maxTime.inMinutes;
    _animation = Tween<double>(
      begin: 0.0,
      end: percent,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedAwayTimeIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.awayTime != widget.awayTime) {
      final percent = widget.awayTime.inMinutes / widget.maxTime.inMinutes;
      _animation = Tween<double>(
        begin: _animation.value,
        end: percent,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.forward(from: 0);
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final timePercent = (_animation.value * 100).toInt();
        final currentMinutes = (widget.awayTime.inMinutes).toString().padLeft(2, '0');

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 40.0,
                  lineWidth: 8.0,
                  percent: _animation.value,
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$currentMinutes분',
                        style: TextStyle(
                          color: widget.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '$timePercent%',
                        style: TextStyle(
                          color: widget.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  progressColor: _getProgressColor(_animation.value),
                  backgroundColor: widget.color.withOpacity(0.2),
                  animation: false,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.color,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }

  Color _getProgressColor(double value) {
    if (value < 0.5) return Colors.green;
    if (value < 0.75) return Colors.yellow;
    return Colors.red;
  }
}