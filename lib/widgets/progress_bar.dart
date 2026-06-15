import 'package:flutter/material.dart';

import '../core/app_colors.dart';

/// A rounded progress bar with a configurable fill color.
class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.height = 10,
  });

  /// Fill ratio in the 0..1 range.
  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor: AppColors.background,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
