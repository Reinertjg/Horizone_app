import 'dart:io';

import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../domain/usecases/profile_usecase.dart';
import '../../generated/l10n.dart';
import '../../repositories/profile_repository_impl.dart';
import '../state/profileform_provider.dart';
import '../state/theme_provider.dart';
import '../theme_color/app_colors.dart';
import '../widgets/interview_widgets/interview_fab.dart';
import '../widgets/interview_widgets/participant_widgets/participant_avatar_picker.dart';
import 'home_screen.dart';

/// Screen used to collect user profile information during onboarding.
class ProfileSetupPhotoScreen extends StatefulWidget {
  /// Creates a [ProfileSetupPhotoScreen] widget.
  const ProfileSetupPhotoScreen({super.key});

  @override
  State<ProfileSetupPhotoScreen> createState() =>
      _ProfileSetupPhotoScreenState();
}

class _ProfileSetupPhotoScreenState extends State<ProfileSetupPhotoScreen> {
  late ProfileFormProvider _profileProvider;
  late File? _image;

  @override
  void initState() {
    super.initState();
    _image = null;
    _profileProvider = Provider.of<ProfileFormProvider>(context, listen: false);
  }

  Future<void> _pickImage(OptionPhotoMode mode) async {
    final picker = ImagePicker();
    final source = mode == OptionPhotoMode.cameraMode
        ? ImageSource.camera
        : ImageSource.gallery;

    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _image = file;
      });
      _profileProvider.setSelectedImage(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileFormProvider>(context);
    final colors = Theme.of(context).extension<AppColors>()!;

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
                    _AppBarWidget(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                    Container(
                      width: 175,
                      height: 175,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.secondary,
                      ),
                      child: ClipOval(
                        child: profileProvider.selectedImage == null
                            ? Image.asset(
                                'assets/images/user_default_photo.png',
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                profileProvider.selectedImage!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    InterviewFab(
                      nameButton: 'Select Profile Photo',
                      onPressed: () async {
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => ImagePickerSheet(
                            onCameraTap: () {
                              _pickImage(OptionPhotoMode.cameraMode);
                            },
                            onGalleryTap: () {
                              _pickImage(OptionPhotoMode.galleryMode);
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 50),

                    Column(
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
                        const SizedBox(height: 18),
                        Text(
                          'Show yout face clearly',
                          style: GoogleFonts.raleway(
                            color: colors.tertiary,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Be a close-up face',
                          style: GoogleFonts.raleway(
                            color: colors.tertiary,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Be clear and sharp',
                          style: GoogleFonts.raleway(
                            color: colors.tertiary,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),



                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22.0,
              vertical: 16.0,
            ),
            child: _SubmitProfileFab(),
          ),
        ],
      ),
    );
  }
}

/// Builds the app bar for the [ProfileSetupPhotoScreen].
/// Includes a back button, a title, and a theme toggle button.
class _AppBarWidget extends StatelessWidget {
  /// Creates a [_AppBarWidget].
  const _AppBarWidget();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final themeProvider = Provider.of<ThemeProvider>(context);
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
          icon: Icon(
            themeProvider.isDarkMode
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

class ImagePickerSheet extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const ImagePickerSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

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
                  color: colors.quaternary.withAlpha(80),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Selecionar foto',
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              /// Image options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ImageOption(
                    icon: Icons.camera_alt_outlined,
                    label: 'Câmera',
                    onTap: onCameraTap,
                    backgroundColor: colors.secondary.withAlpha(50),
                    iconColor: colors.secondary,
                  ),
                  _ImageOption(
                    icon: Icons.photo_library_outlined,
                    label: 'Galeria',
                    onTap: onGalleryTap,
                    backgroundColor: colors.tertiary.withAlpha(50),
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
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  const _ImageOption({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
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
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

/// A floating action button widget for submitting the profile form.
class _SubmitProfileFab extends StatelessWidget {
  /// Creates a [_SubmitProfileFab] widget.
  const _SubmitProfileFab();

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<ProfileFormProvider>(
      context,
      listen: false,
    );
    return InterviewFab(
      nameButton: S.of(context).continueButton,
      onPressed: () async {
        final profile = formProvider.toEntity();

        final repository = ProfileRepositoryImpl();
        final useCase = ProfileUseCase(repository);

        print('Entidade: $profile');
        print('Image: ${profile.photo}');
        print('Image: ${formProvider.selectedImage}');
        await useCase.insert(profile);
        if (!context.mounted) return;
        await Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      },
    );
  }
}
