
import 'package:flutter/material.dart';

import '../theme_color/app_colors.dart';

/// The profile screen
/// Visuall representation of the user's profile
/// And update or delete options
class ProfileScreen extends StatelessWidget {
  /// Creates a [ProfileScreen] widget.
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.primary,
    );
  }
}
