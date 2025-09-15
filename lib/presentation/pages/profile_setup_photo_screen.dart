import 'dart:io' show File;

import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/profile.dart';
import '../../generated/l10n.dart';
import '../../util/option_dialog.dart';
import '../state/profile_provider.dart';
import '../state/theme_provider.dart';
import '../theme_color/app_colors.dart';
import '../widgets/bottom_sheet_widgets/options_image_modal.dart';
import '../widgets/interview_widgets/interview_fab.dart';
import '../widgets/interview_widgets/participant_widgets/participant_avatar_picker.dart'
    show OptionPhotoMode;
import '../widgets/show_dialog_image.dart';
import 'home_screen.dart';

/// Screen used to collect user profile information during onboarding.
/// UI-only: all business logic lives in the provider/controller.
class ProfileSetupPhotoScreen extends StatelessWidget {
  /// Creates a custom [ProfileSetupPhotoScreen].
  const ProfileSetupPhotoScreen({super.key, required this.profile});

  /// The profile data to be displayed.
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final profileProvider = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: colors.primary,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 22.0,
                  top: 30,
                  right: 22.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _AppBarWidget(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                    _AvatarPreview(image: profileProvider.photo),
                    const SizedBox(height: 40),
                    InterviewFab(
                      nameButton: 'Select Profile Photo',
                      onPressed: () async {
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => ImagePickerSheet(
                            title: 'Opções',
                            onCameraTap: () {
                              Navigator.pop(context);
                              context.read<ProfileProvider>().pickImage(
                                OptionPhotoMode.cameraMode,
                              );
                            },
                            onVisualizeTap: () {
                              showDialogImage(
                                context,
                                profile.photo!,
                                MainAxisAlignment.start,
                              );
                            },
                            onGalleryTap: () {
                              Navigator.pop(context);
                              context.read<ProfileProvider>().pickImage(
                                OptionPhotoMode.galleryMode,
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                    const _PhotoGuidelines(),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
            child: _SubmitProfileFab(),
          ),
        ],
      ),
    );
  }
}

/// Builds the app bar for the profile photo screen.
/// Includes a back button, a title, and a theme toggle button.
class _AppBarWidget extends StatelessWidget {
  const _AppBarWidget();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final themeProvider = context.watch<ThemeProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, size: 30, color: colors.quaternary),
          onPressed: () {
            Navigator.pushNamed(context, '/profileSetup');
          },
        ),
        Text(
          'Add Profile Photo',
          style: TextStyle(
            color: colors.tertiary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () {
            themeProvider.toggleTheme(isOn: !themeProvider.isDarkMode);
          },
          icon: HugeIcon(
            icon: themeProvider.isDarkMode
                ? HugeIcons.strokeRoundedMoon02
                : HugeIcons.strokeRoundedSun03,
            size: 25,
            color: colors.quaternary,
          ),
        ),
      ],
    );
  }
}

/// Circular avatar preview: shows default asset or the picked file.
class _AvatarPreview extends StatelessWidget {
  final File? image;

  const _AvatarPreview({required this.image});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      width: 175,
      height: 175,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.secondary,
      ),
      child: ClipOval(
        child: image == null
            ? Image.asset(
                'assets/images/user_default_photo.png',
                fit: BoxFit.cover,
              )
            : Image.file(image!, fit: BoxFit.cover),
      ),
    );
  }
}

/// Photo guidelines block.
class _PhotoGuidelines extends StatelessWidget {
  const _PhotoGuidelines();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    var itemStyle = GoogleFonts.raleway(color: colors.tertiary, fontSize: 20);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Photo Should',
          style: GoogleFonts.raleway(
            color: colors.tertiary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 26),
        Text('Show your face clearly', style: itemStyle),
        const SizedBox(height: 12),
        Text('Be a close-up face', style: itemStyle),
        const SizedBox(height: 12),
        Text('Be clear and sharp', style: itemStyle),
      ],
    );
  }
}

/// Submit FAB that delegates side-effects to the provider/controller.
class _SubmitProfileFab extends StatelessWidget {
  const _SubmitProfileFab();

  @override
  Widget build(BuildContext context) {
    final formProvider = context.watch<ProfileProvider>();
    return InterviewFab(
      nameButton: S.of(context).continueButton,
      onPressed: () async {
        if (formProvider.photo == null) {
          final shouldContinue = await showDialog(
            context: context,
            builder: (context) => OptionDialog(
              title: 'No Photo Selected',
              message: 'Do you want to continue without a photo?',
              buttonText: S.of(context).continueButton,
            ),
          );
          if (shouldContinue == true) {
            if (!context.mounted) return;
            await _submitAndNavigate(context, formProvider);
          }
        } else {
          await _submitAndNavigate(context, formProvider);
        }
      },
    );
  }

  Future<void> _submitAndNavigate(
    BuildContext context,
    ProfileProvider formProvider,
  ) async {
    await formProvider.submitProfile(context);
    if (!context.mounted) return;
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }
}
