import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/profile.dart';
import '../../domain/usecases/profile_usecase.dart';
import '../../generated/l10n.dart';
import '../../repositories/profile_repository_impl.dart';
import '../../util/show_app_snackbar.dart';
import '../state/profile_provider.dart';
import '../theme_color/app_colors.dart';
import '../widgets/bottom_sheet_widgets/options_image_modal.dart';
import '../widgets/iconbutton_settings.dart';
import '../widgets/interview_widgets/build_dropdownform.dart';
import '../widgets/interview_widgets/cupertino_date_picker.dart';
import '../widgets/interview_widgets/interview_fab.dart';
import '../widgets/interview_widgets/interview_textfield.dart';
import '../widgets/interview_widgets/interview_textfield_box.dart';
import '../widgets/interview_widgets/participant_widgets/participant_avatar_picker.dart';
import '../widgets/section_title.dart';
import '../widgets/show_dialog_image.dart';
import 'getstarted_screen.dart';

/// Screen for displaying and editing the user's profile.
class ProfileScreen extends StatefulWidget {
  /// Creates a custom [ProfileScreen].
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true;
  bool _editing = false;
  Profile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final provider = context.read<ProfileProvider>();
    setState(() => _loading = true);
    try {
      if (!mounted) return;
      await provider.loadProfileData();
      setState(() => _profile = provider.toEntity());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleEditing() async {
    final provider = context.read<ProfileProvider>();
    await provider.loadProfileData();
    setState(() => _editing = !_editing);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final profileProvider = context.watch<ProfileProvider>();
    return Scaffold(
      backgroundColor: colors.primary,
      appBar: ProfileAppBar(
        isEditing: _editing,
        onToggleEditing: _toggleEditing,
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _profile == null
            ? Center(
                child: Text(
                  'Nenhum perfil encontrado',
                  style: GoogleFonts.nunito(color: colors.quaternary),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    AvatarProfile(
                      profile: _profile!,
                      isEditing: _editing,
                      onImageUpdated: _loadProfile,
                    ),
                    const SizedBox(height: 12),
                    ProfileHeader(
                      profile: profileProvider.toEntity(),
                      isEditing: _editing,
                      onProfileUpdated: _loadProfile,
                    ),
                    const SizedBox(height: 32),
                    ProfileInfo(
                      profile: _profile!,
                      isEditing: _editing,
                      onProfileUpdated: _loadProfile,
                    ),
                    const SizedBox(height: 32),
                    const DeleteAccountTile(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }
}

/// The app bar for the profile screen.
class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a [ProfileAppBar].
  const ProfileAppBar({
    super.key,
    required this.isEditing,
    required this.onToggleEditing,
  });

  /// Whether the profile is currently being edited.
  final bool isEditing;

  /// A callback to toggle the editing mode.
  final VoidCallback onToggleEditing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return AppBar(
      backgroundColor: colors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        S.of(context).profile,
        style: GoogleFonts.nunito(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: colors.secondary,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        _IconbuttonEditProfile(editing: isEditing, onPressed: onToggleEditing),
        const SizedBox(width: 12),
        const IconbuttonSettings(),
        const SizedBox(width: 12),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _IconbuttonEditProfile extends StatelessWidget {
  const _IconbuttonEditProfile({
    required this.editing,
    required this.onPressed,
  });

  final bool editing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Card(
      color: editing ? colors.tertiary : colors.quinary,
      shape: const CircleBorder(),
      elevation: 2,
      child: SizedBox(
        height: 38,
        width: 38,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            editing
                ? HugeIcons.strokeRoundedTick02
                : HugeIcons.strokeRoundedEdit03,
            color: colors.quaternary,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

/// A widget to display the user's avatar.
class AvatarProfile extends StatelessWidget {
  /// Creates an [AvatarProfile] widget.
  const AvatarProfile({
    super.key,
    required this.profile,
    required this.isEditing,
    required this.onImageUpdated,
  });

  /// The user's profile data.
  final Profile profile;

  /// Whether the profile is in editing mode.
  final bool isEditing;

  /// A callback to update the user's image.
  final Future<void> Function() onImageUpdated;

  Future<void> _pickAndUploadImage(
    BuildContext context,
    OptionPhotoMode mode,
  ) async {
    final check = await context.read<ProfileProvider>().pickImageData(
      mode,
      profile.id!,
    );
    if (check && context.mounted) {
      await onImageUpdated();
      if (!context.mounted) return;
      showAppSnackbar(
        context: context,
        snackbarMode: SnackbarMode.success,
        message: 'Foto atualizada com sucesso!',
        iconData: HugeIcons.strokeRoundedImageDone01,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: () async {
        if (!isEditing) {
          showDialogImage(context, profile.photo!, MainAxisAlignment.center);
          return;
        }

        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ImagePickerSheet(
            title: 'Configurações',
            onCameraTap: () async {
              Navigator.pop(context);
              await _pickAndUploadImage(context, OptionPhotoMode.cameraMode);
            },
            onVisualizeTap: () {
              showDialogImage(context, profile.photo!, MainAxisAlignment.start);
            },
            onGalleryTap: () async {
              Navigator.pop(context);
              await _pickAndUploadImage(context, OptionPhotoMode.galleryMode);
            },
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            width: 155,
            height: 155,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.secondary,
              border: Border.all(color: colors.secondary, width: 3),
            ),
            child: ClipOval(
              child: profile.photo == null
                  ? Image.asset(
                      'assets/images/user_default_photo.png',
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      profile.photo!,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      frameBuilder: (context, child, frame, wasSync) {
                        if (wasSync) return child;
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          layoutBuilder: (currentChild, previousChildren) =>
                              Stack(
                                fit: StackFit.expand,
                                children: [
                                  ...previousChildren,
                                  if (currentChild != null) currentChild,
                                ],
                              ),
                          child: frame == null
                              ? SizedBox.expand(
                                  child: Center(
                                    child: SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: colors.tertiary,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox.expand(child: child),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/user_default_photo.png',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),
          ),
          if (isEditing)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.tertiary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.primary, width: 3),
                ),
                child: const Icon(
                  HugeIcons.strokeRoundedEdit03,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A widget to display the user's name and biography.
class ProfileHeader extends StatelessWidget {
  /// Creates a [ProfileHeader] widget.
  const ProfileHeader({
    super.key,
    required this.profile,
    required this.isEditing,
    required this.onProfileUpdated,
  });

  /// The user's profile data.
  final Profile profile;

  /// Whether the profile is in editing mode.
  final bool isEditing;

  /// A callback to update the user's name and biography.
  final Future<void> Function() onProfileUpdated;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final profileProvider = context.read<ProfileProvider>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: isEditing
              ? () async {
                  await showDialog(
                    context: context,
                    builder: (context) => OptionDialog(
                      title: 'Alterar Nome',
                      buttonText: S.of(context).continueButton,
                      field: InterviewTextField(
                        nameButton: S.of(context).name,
                        hintText: 'Nome Completo',
                        icon: HugeIcons.strokeRoundedUser,
                        controller: profileProvider.nameController,
                        validator: profileProvider.validateName,
                      ),
                      onProfileUpdated: onProfileUpdated,
                    ),
                  );
                }
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  profile.name,
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (isEditing)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    HugeIcons.strokeRoundedEdit03,
                    color: colors.quaternary.withValues(alpha: 0.5),
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: isEditing
              ? () async {
                  await showDialog(
                    context: context,
                    builder: (context) => OptionDialog(
                      title: 'Alterar Nome',
                      buttonText: S.of(context).continueButton,
                      field: InterviewTextFieldBox(
                        nameButton: S.of(context).bio,
                        hintText: S.of(context).bioDescription,
                        icon: HugeIcons.strokeRoundedTextIndent01,
                        controller: profileProvider.bioController,
                        validator: profileProvider.validateBio,
                      ),
                      onProfileUpdated: onProfileUpdated,
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    profile.biography,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: colors.quaternary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (isEditing)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      HugeIcons.strokeRoundedEdit03,
                      color: colors.quaternary.withValues(alpha: 0.5),
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A widget to display general information about the user.
class ProfileInfo extends StatelessWidget {
  /// Creates a [ProfileInfo] widget.
  const ProfileInfo({
    super.key,
    required this.profile,
    required this.isEditing,
    required this.onProfileUpdated,
  });

  /// The user's profile data.
  final Profile profile;

  /// Whether the profile is in editing mode.
  final bool isEditing;

  /// A callback to update the user's information.
  final Future<void> Function() onProfileUpdated;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final profileProvider = context.read<ProfileProvider>();
    final eighteenthBirthday = DateTime.now().subtract(
      const Duration(days: 365 * 18),
    );
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.quinary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle(
            title: S.of(context).generalInformation,
            icon: HugeIcons.strokeRoundedInformationCircle,
          ),
          const SizedBox(height: 12),
          InfoField(
            icon: HugeIcons.strokeRoundedCalendar03,
            label: S.of(context).dateOfBirth,
            info: profile.birthDate,
            isEditing: isEditing,
            field: CupertinoDatePickerField(
              label: S.of(context).dateOfBirth,
              fontSize: 12,
              icon: HugeIcons.strokeRoundedCalendar03,
              controller: profileProvider.dateOfBirthController,
              validator: profileProvider.validateDateOfBirth,
              maxDate: eighteenthBirthday,
              minDate: DateTime(1900),
              initialDate: profileProvider.dateOfBirth ?? eighteenthBirthday,
              onDateChanged: profileProvider.setDateOfBirth,
            ),
            onProfileUpdated: onProfileUpdated,
          ),
          const SizedBox(height: 12),
          InfoField(
            icon: HugeIcons.strokeRoundedUserLove01,
            label: S.of(context).gender,
            info: profile.gender,
            isEditing: isEditing,
            field: BuildDropdownform(
              label: S.of(context).gender,
              items: ['Masculino', 'Feminino', 'Outro'],
              icon: HugeIcons.strokeRoundedUserLove01,
              value: (profileProvider.gender?.isEmpty ?? true)
                  ? null
                  : profileProvider.gender,
              validator: profileProvider.validateGender,
              onChanged: (value) => profileProvider.gender = value,
            ),
            onProfileUpdated: onProfileUpdated,
          ),
          const SizedBox(height: 12),
          InfoField(
            icon: HugeIcons.strokeRoundedJobLink,
            label: S.of(context).jobTitle,
            info: profile.jobTitle,
            isEditing: isEditing,
            field: InterviewTextField(
              nameButton: S.of(context).jobTitle,
              hintText: 'Cargo',
              icon: HugeIcons.strokeRoundedJobLink,
              controller: profileProvider.jobTitleController,
              validator: profileProvider.validateJobTitle,
            ),
            onProfileUpdated: onProfileUpdated,
          ),
        ],
      ),
    );
  }
}

/// A field to display a piece of information, with an option to edit it.
class InfoField extends StatelessWidget {
  /// Creates an [InfoField] widget.
  const InfoField({
    super.key,
    required this.icon,
    required this.label,
    required this.info,
    this.isEditing = false,
    required this.field,
    required this.onProfileUpdated,
  });

  /// The icon to display next to the information.
  final IconData icon;

  /// The label for the information.
  final String label;

  /// The information to display.
  final String info;

  /// Whether the field is in editing mode.
  final bool isEditing;

  /// The widget to display in the dialog when editing.
  final Widget field;

  /// A callback to update the information.
  final Future<void> Function() onProfileUpdated;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: isEditing
          ? () {
              showDialog(
                context: context,
                builder: (context) => OptionDialog(
                  title: label,
                  buttonText: S.of(context).continueButton,
                  field: field,
                  onProfileUpdated: onProfileUpdated,
                ),
              );
            }
          : null,
      child: Row(
        children: [
          Icon(icon, color: colors.secondary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.quaternary.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  info,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colors.quaternary,
                  ),
                ),
              ],
            ),
          ),
          if (isEditing)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                HugeIcons.strokeRoundedEdit03,
                color: colors.quaternary.withValues(alpha: 0.5),
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}

/// A widget that displays a red "Delete Account" text button.
class DeleteAccountTile extends StatelessWidget {
  /// Creates a [DeleteAccountTile] widget.
  const DeleteAccountTile({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const _ConfirmDeleteDialog(),
        );
      },
      child: Text(
        S.of(context).deleteAccount,
        style: const TextStyle(color: Color(0xFFA50101)),
      ),
    );
  }
}

class _ConfirmDeleteDialog extends StatelessWidget {
  const _ConfirmDeleteDialog();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: colors.primary,
      title: Text(
        S.of(context).deleteAccountAsk,
        style: GoogleFonts.nunito(color: const Color(0xFFA50101)),
      ),
      content: Text(
        S.of(context).deleteMessage,
        style: GoogleFonts.raleway(color: colors.quaternary),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text(
            S.of(context).cancel,
            style: TextStyle(color: colors.quaternary),
          ),
        ),
        TextButton(
          onPressed: () async {
            final repository = ProfileRepositoryImpl();
            final useCase = ProfileUseCase(repository);
            await useCase.delete();
            if (!context.mounted) return;
            await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const GetStartedScreen()),
              (route) => false,
            );
          },
          child: const Text(
            'Delete',
            style: TextStyle(color: Color(0xFFA50101)),
          ),
        ),
      ],
    );
  }
}

/// Dialog for selecting an option.
class OptionDialog extends StatefulWidget {
  /// The title of the dialog.
  final String title;

  /// The text for the confirmation button.
  final String buttonText;

  /// The form field widget to be displayed in the dialog.
  final Widget field;

  /// Callback function to be executed when the profile is updated.
  final Future<void> Function() onProfileUpdated;

  /// Creates an [OptionDialog].
  const OptionDialog({
    super.key,
    required this.title,
    required this.buttonText,
    required this.field,
    required this.onProfileUpdated,
  });

  @override
  State<OptionDialog> createState() => _OptionDialogState();
}

class _OptionDialogState extends State<OptionDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final profileProvider = context.read<ProfileProvider>();

    return ScaleTransition(
      scale: _animation,
      child: AlertDialog(
        backgroundColor: colors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Text(widget.title, style: TextStyle(color: colors.quaternary)),
        titlePadding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
        contentPadding: const EdgeInsets.fromLTRB(18, 18, 18, 0),

        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [widget.field],
            ),
          ),
        ),

        actions: [
          Row(
            children: <Widget>[
              Expanded(
                child: InterviewFab(
                  nameButton: S.of(context).cancel,
                  onPressed: () async {
                    Navigator.of(context).pop(false);
                    await widget.onProfileUpdated();
                    if (!context.mounted) return;
                    showAppSnackbar(
                      context: context,
                      snackbarMode: SnackbarMode.info,
                      iconData: HugeIcons.strokeRoundedAlert01,
                      message: 'Nenhuma alteração realizada!',
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InterviewFab(
                  nameButton: widget.buttonText,
                  onPressed: () async {
                    final isValid = _formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    _formKey.currentState?.save();

                    final useCase = ProfileUseCase(ProfileRepositoryImpl());
                    await useCase.updateProfile(profileProvider.toEntity());

                    await widget.onProfileUpdated();
                    if (!context.mounted) return;

                    showAppSnackbar(
                      context: context,
                      snackbarMode: SnackbarMode.success,
                      iconData: HugeIcons.strokeRoundedTick02,
                      message: 'Perfil atualizado com sucesso!',
                    );

                    if (!context.mounted) return;
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
            ],
          ),
        ],
        actionsPadding: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
