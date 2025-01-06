import 'package:flutter/material.dart';

/// A custom loader widget that shows a circular progress indicator.
class Loader extends StatefulWidget {
  /// Loader Constructor
  const Loader({
    super.key,
    this.size = 50.0,
    this.color = Colors.red,
    this.showText = false,
    this.strokeWidth = 4.0,
  });

  /// Size of the loader
  final double size;

  /// Color of the loader
  final Color color;

  /// Whether to show the text or not
  final bool? showText;

  /// Stroke width of the loader
  final double strokeWidth;

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                strokeWidth: widget.strokeWidth,
                valueColor: AlwaysStoppedAnimation<Color>(widget.color),
              ),
            ),
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Container(
                  width: widget.size * 0.5,
                  height: widget.size * 0.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:

                        /// ignoring because dont have time to fix
                        // ignore: deprecated_member_use
                        widget.color.withOpacity(0.3 * _pulseAnimation.value),
                  ),
                );
              },
            ),
          ],
        ),
        if (widget.showText ?? false) ...[
          const SizedBox(height: 16),
          DefaultTextStyle(
            style: TextStyle(
              color: widget.color,
              fontSize: widget.size * 0.3,
              fontWeight: FontWeight.w500,
            ),
            child: const Text('Loading...'),
          ),
        ],
      ],
    );
  }
}
