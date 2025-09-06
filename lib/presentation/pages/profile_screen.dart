
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme_color/app_colors.dart';
import '../widgets/iconbutton_settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.primary,
      appBar: const _ProfileAppBar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),

          ],
        )

      ),
    );
  }
}

class _ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProfileAppBar();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return AppBar(
      backgroundColor: colors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
       title: Text(
       'Profile',
        style: GoogleFonts.nunito(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: colors.secondary,
        ),
        textAlign: TextAlign.center,
       ),
      actions: [
        IconbuttonSettings(),
        const SizedBox(width: 12),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
