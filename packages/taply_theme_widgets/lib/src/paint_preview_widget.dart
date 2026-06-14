import 'package:flutter/material.dart';
import 'package:taply_theme_engine/taply_theme_engine.dart';

/// A simple preview widget for displaying paint results.
class PaintPreviewWidget extends StatelessWidget {
  final PaintMetrics metrics;
  final double width;
  final double height;

  const PaintPreviewWidget({
    super.key,
    required this.metrics,
    this.width = 600,
    this.height = 400,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Painted: ${metrics.paintedNodes}'),
            if (metrics.recoveredNodes > 0)
              Text('Recovered: ${metrics.recoveredNodes}'),
            if (metrics.failedNodes > 0)
              Text('Failed: ${metrics.failedNodes}',
                  style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
