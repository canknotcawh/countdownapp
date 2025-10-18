import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ProgressRing extends StatefulWidget {
  const ProgressRing({
    super.key,
    required this.target,
    this.baseColor = Colors.white,
    this.strokeWidth = 8,
  });

  final DateTime target;
  final Color baseColor;
  final double strokeWidth;

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final total = const Duration(days: 365).inSeconds.toDouble();
    final remaining = (widget.target.difference(now).inSeconds).toDouble();
    final clamped = remaining.clamp(0, total);
    final progress = 1 - (clamped / total);

    return CustomPaint(
      painter: _RingPainter(
        progress: progress,
        color: widget.baseColor,
        stroke: widget.strokeWidth,
      ),
      child: Center(
        child: Text(
          _compactRemaining(widget.target),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.color,
    required this.stroke,
  });

  final double progress;
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - stroke / 2;

    final bg = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final fg = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + 2 * math.pi,
        colors: [
          color,
          color.withValues(alpha: 0.6), 
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bg);

    final sweep = 2 * math.pi * progress;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, fg);
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.stroke != stroke;
}

String _compactRemaining(DateTime target) {
  final now = DateTime.now();
  final diff = target.difference(now);

  if (diff.isNegative) return "0s";

  if (diff.inDays > 0) return "${diff.inDays}d";
  if (diff.inHours > 0) return "${diff.inHours}h";
  if (diff.inMinutes > 0) return "${diff.inMinutes}m";
  return "${diff.inSeconds}s";
}
