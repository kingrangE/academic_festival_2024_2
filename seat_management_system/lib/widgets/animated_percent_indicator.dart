// lib/widgets/animated_percent_indicator.dart
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AnimatedPercentIndicator extends StatefulWidget {
  final String label;
  final double percent;
  final Color color;
  final Duration duration;

  const AnimatedPercentIndicator({
    Key? key,
    required this.label,
    required this.percent,
    required this.color,
    required this.duration,
  }) : super(key: key);

  @override
  State<AnimatedPercentIndicator> createState() => _AnimatedPercentIndicatorState();
}

class _AnimatedPercentIndicatorState extends State<AnimatedPercentIndicator>
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

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.percent,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getProgressColor(double value) {
    if (widget.label.contains('Away Time')) {
      if (value < 0.5) return Colors.green;
      if (value < 0.75) return Colors.yellow;
      return Colors.red;
    }
    return widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final bool isAwayTime = widget.label.contains('Away Time');
        final String centerText = isAwayTime
            ? '${(widget.percent * 120).toInt()}분'
            : '${(_animation.value * 100).toInt()}%';

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 8.0,
              percent: _animation.value,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    centerText,
                    style: TextStyle(
                      color: widget.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  if (isAwayTime)
                    Text(
                      '${(_animation.value * 100).toInt()}%',
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
}