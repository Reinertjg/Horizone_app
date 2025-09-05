import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import '../../../state/stop_provider.dart';
import '../../../theme_color/app_colors.dart';

/// Button to add a new stop to the travel route.
class AddStopButton extends StatelessWidget {
  /// Creates an [AddStopButton] widget.
  const AddStopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.secondary.withValues(alpha: 0.6),
            colors.secondary.withRed(102).withGreen(178).withBlue(255).withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.secondary),
      ),
      child: ElevatedButton(
        onPressed: () => context.read<StopProvider>().addStop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(HugeIcons.strokeRoundedPlayListAdd, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              'Adicionar Parada',
              style: GoogleFonts.raleway(
                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
