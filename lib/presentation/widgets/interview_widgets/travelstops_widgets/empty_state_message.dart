import 'package:flutter/material.dart';
import '../../../theme_color/app_colors.dart';

/// Widget for displaying an empty state message.
class EmptyStateMessage extends StatelessWidget {
  /// Constructs an [EmptyStateMessage] widget.
  const EmptyStateMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  /// The icon to display.
  final IconData icon;

  /// The title to display.
  final String title;

  /// The subtitle to display.
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          Icon(icon, size: 48, color: colors.secondary.withValues(alpha: 0.3)),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: colors.secondary.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: colors.secondary.withValues(alpha: 0.5),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
