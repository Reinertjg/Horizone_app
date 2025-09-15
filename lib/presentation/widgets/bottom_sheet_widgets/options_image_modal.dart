import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../theme_color/app_colors.dart';

/// A bottom sheet that presents options for picking an image.
class ImagePickerSheet extends StatelessWidget {
  /// Creates an [ImagePickerSheet].
  const ImagePickerSheet({
    super.key,
    required this.title,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.onVisualizeTap,
  });

  /// The title of the camera option.
  final String title;

  /// The callback that is executed when the camera option is tapped.
  final VoidCallback onCameraTap;

  /// The callback that is executed when the gallery option is tapped.
  final VoidCallback onGalleryTap;

  /// The callback that is executed when the visualize option is tapped.
  final VoidCallback onVisualizeTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: DefaultTextStyle(
          style: GoogleFonts.raleway(color: colors.quaternary),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.quaternary.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Configurações',
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ImageOption(
                    icon: HugeIcons.strokeRoundedCameraAdd03,
                    label: 'title',
                    onTap: onCameraTap,
                    backgroundColor: colors.secondary.withValues(alpha: 0.5),
                    iconColor: colors.secondary,
                  ),
                  _ImageOption(
                    icon: HugeIcons.strokeRoundedVision,
                    label: 'Visualizar',
                    onTap: onVisualizeTap,
                    backgroundColor: colors.secondary.withValues(alpha: 0.5),
                    iconColor: colors.secondary,
                  ),
                  _ImageOption(
                    icon: HugeIcons.strokeRoundedAlbum01,
                    label: 'Galeria',
                    onTap: onGalleryTap,
                    backgroundColor: colors.tertiary.withValues(alpha: 0.5),
                    iconColor: colors.tertiary,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageOption extends StatelessWidget {
  const _ImageOption({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: iconColor),
          ),
          SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
