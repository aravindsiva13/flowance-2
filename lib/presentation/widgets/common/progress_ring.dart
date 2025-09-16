// lib/presentation/widgets/common/progress_ring.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProgressRing extends StatefulWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;
  final bool showPercentage;
  final TextStyle? textStyle;
  final bool animated;
  final Duration animationDuration;

  const ProgressRing({
    Key? key,
    required this.progress,
    this.size = 100,
    this.strokeWidth = 8,
    required this.color,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.showPercentage = true,
    this.textStyle,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 1000),
  }) : super(key: key);

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.animated) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(ProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      
      if (widget.animated) {
        _animationController.reset();
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress ring
          widget.animated
              ? AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: ProgressRingPainter(
                        progress: _animation.value,
                        strokeWidth: widget.strokeWidth,
                        color: widget.color,
                        backgroundColor: widget.backgroundColor,
                      ),
                    );
                  },
                )
              : CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: ProgressRingPainter(
                    progress: widget.progress,
                    strokeWidth: widget.strokeWidth,
                    color: widget.color,
                    backgroundColor: widget.backgroundColor,
                  ),
                ),
          // Percentage text
          if (widget.showPercentage)
            widget.animated
                ? AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Text(
                        '${(_animation.value * 100).toInt()}%',
                        style: widget.textStyle ??
                            TextStyle(
                              fontSize: widget.size * 0.15,
                              fontWeight: FontWeight.bold,
                              color: widget.color,
                            ),
                      );
                    },
                  )
                : Text(
                    '${(widget.progress * 100).toInt()}%',
                    style: widget.textStyle ??
                        TextStyle(
                          fontSize: widget.size * 0.15,
                          fontWeight: FontWeight.bold,
                          color: widget.color,
                        ),
                  ),
        ],
      ),
    );
  }
}

class ProgressRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Color backgroundColor;

  ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final rect = Rect.fromCircle(center: center, radius: radius);
      const startAngle = -math.pi / 2; // Start from top
      final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);

      canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.color != color ||
           oldDelegate.backgroundColor != backgroundColor ||
           oldDelegate.strokeWidth != strokeWidth;
  }
}