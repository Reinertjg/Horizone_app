import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../domain/usecases/profile_usecase.dart';
import '../../generated/l10n.dart';
import '../../repositories/profile_repository_impl.dart';
import '../state/profileform_provider.dart';
import '../state/theme_provider.dart';
import '../theme_color/app_colors.dart';
import '../widgets/interview_widgets/build_dropdownform.dart';
import '../widgets/interview_widgets/cupertino_date_picker.dart';
import '../widgets/interview_widgets/interview_fab.dart';
import '../widgets/interview_widgets/interview_textfield.dart';
import '../widgets/interview_widgets/interview_textfield_box.dart';
import '../widgets/profile_widgets/profile_info_text.dart';
import 'home_screen.dart';

/// Screen used to collect user profile information during onboarding.
class ProfileSetUpScreen extends StatefulWidget {
  /// Creates a [ProfileSetUpScreen] widget.
  const ProfileSetUpScreen({super.key});

  @override
  State<ProfileSetUpScreen> createState() => _ProfileSetUpScreenState();
}

class _ProfileSetUpScreenState extends State<ProfileSetUpScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final formKey = GlobalKey<FormState>();

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AppBarWidget(),
                    const SizedBox(height: 40),
                    const _ProfileInfoTextWidget(),
                    _ProfileForm(formKey),
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
            child: _SubmitProfileFab(formKey: formKey),
          ),
        ],
      ),
    );
  }
}

/// Builds the app bar for the [ProfileSetUpScreen].
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
            Navigator.pushNamed(context, '/getStarted');
          },
        ),
        Text(
          S.of(context).profile,
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

/// A widget that displays the introductory text for the profile setup screen.
class _ProfileInfoTextWidget extends StatelessWidget {
  /// Creates a [_ProfileInfoTextWidget].
  const _ProfileInfoTextWidget();

  @override
  Widget build(BuildContext context) {
    return ProfileInfoText(
      tellUs: S.of(context).tellUs,
      whoYouAre: S.of(context).whoYouAre,
      andWellTake: S.of(context).andWellTake,
    );
  }
}

/// A widget that contains the form for user profile information.
class _ProfileForm extends StatelessWidget {
  /// Creates a [_ProfileForm].
  const _ProfileForm(this.formKey);

  /// The form key used to validate the form.
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<ProfileFormProvider>(context);

    /// Variables that handle the CupertinoDatePickerField
    final now = DateTime.now();
    final maxDate = DateTime(now.year - 18, now.month, now.day);
    final minDate = DateTime(1900);
    final initialDate = maxDate;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          InterviewTextField(
            nameButton: S.of(context).name,
            hintText: 'Nome Completo',
            icon: HugeIcons.strokeRoundedUser,
            controller: formProvider.nameController,
            validator: formProvider.validateName,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 7),
          InterviewTextFieldBox(
            nameButton: S.of(context).bio,
            hintText: S.of(context).bioDescription,
            icon: HugeIcons.strokeRoundedTextIndent01,
            controller: formProvider.bioController,
            validator: formProvider.validateBio,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 7),
          CupertinoDatePickerField(
            label: S.of(context).dateOfBirth,
            fontSize: 12,
            icon: HugeIcons.strokeRoundedCalendar03,
            controller: formProvider.dateOfBirthController,
            validator: formProvider.validateDateOfBirth,
            maxDate: maxDate,
            minDate: minDate,
            initialDate: initialDate,
          ),
          const SizedBox(height: 7),
          BuildDropdownform(
            label: S.of(context).gender,
            items: ['Masculino', 'Feminino', 'Outro'],
            icon: HugeIcons.strokeRoundedUserLove01,
            validator: formProvider.validateGender,
            onChanged: (value) => formProvider.gender = value,
          ),
          const SizedBox(height: 7),
          InterviewTextField(
            nameButton: S.of(context).jobTitle,
            hintText: 'Cargo',
            icon: HugeIcons.strokeRoundedJobLink,
            controller: formProvider.jobTitleController,
            validator: formProvider.validateJobTitle,
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}

/// A floating action button widget for submitting the profile form.
class _SubmitProfileFab extends StatelessWidget {
  /// Creates a [_SubmitProfileFab] widget.
  const _SubmitProfileFab({required this.formKey});

  /// The form key used to validate the form.
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<ProfileFormProvider>(
      context,
      listen: false,
    );
    return InterviewFab(
      nameButton: S.of(context).continueButton,
      onPressed: () async {
        if (formProvider.validateAll(formKey)) {
          final profile = formProvider.toEntity();

          final repository = ProfileRepositoryImpl();
          final useCase = ProfileUseCase(repository);

          await useCase.insert(profile);
          if (!context.mounted) return;
          await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          );
        }
      },
    );
  }
}
