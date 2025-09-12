import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../util/travel_status.dart';
import '../../theme_color/app_colors.dart';
import 'blinking_dot.dart';

/// Widget that displays the status of the travel.
class StatusChip extends StatelessWidget {
  /// Creates a [TTravelStatus] widget.
  const StatusChip({required this.status});

  /// The status of the travel.
  final TravelStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final Color statusColor;
    final String statusText;

    switch (status) {
      case TravelStatus.inProgress:
        statusColor = Colors.green;
        statusText = 'Em andamento';
        break;
      case TravelStatus.completed:
        statusColor = Colors.blue;
        statusText = 'Concluída';
        break;
      case TravelStatus.canceled:
        statusColor = Colors.red;
        statusText = 'Cancelada';
        break;
      case TravelStatus.scheduled:
        statusColor = Colors.orange;
        statusText = 'Agendada';
        break;
    }

    return Positioned(
      top: 18,
      left: 15,
      child: Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: colors.quaternary.withValues(alpha: 0.7),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlinkingDot(color: statusColor),
            const SizedBox(width: 6),
            Text(
              statusText,
              style: GoogleFonts.nunito(
                color: colors.quinary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}