import 'package:flutter/material.dart';

import '../core/alerts.dart';
import '../core/app_colors.dart';

/// Inline colored banner that renders a single [BudgetAlert].
class AlertBanner extends StatelessWidget {
  const AlertBanner({super.key, required this.alert});

  final BudgetAlert alert;

  Color get _color {
    switch (alert.severity) {
      case AlertSeverity.danger:
        return AppColors.danger;
      case AlertSeverity.warning:
        return AppColors.warning;
      case AlertSeverity.info:
        return AppColors.primary;
    }
  }

  IconData get _icon {
    switch (alert.severity) {
      case AlertSeverity.danger:
        return Icons.error_outline;
      case AlertSeverity.warning:
        return Icons.warning_amber_rounded;
      case AlertSeverity.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(_icon, color: _color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              alert.message,
              style: TextStyle(color: _color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
