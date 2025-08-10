
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../state/profileform_provider.dart';
import '../state/theme_provider.dart';
import '../theme_color/app_colors.dart';
import '../widgets/continue_button.dart';
import '../widgets/interview_widgets/build_dropdownform.dart';
import '../widgets/interview_widgets/cupertino_textfield.dart';
import '../widgets/interview_widgets/interview_textfield.dart';
import '../widgets/interview_widgets/interview_textfield_box.dart';
import '../widgets/profile_widgets/profile_info_text.dart';

/// Screen used to collect user profile information during onboarding.
class ProfileSetUpScreen extends StatelessWidget {
  /// Creates a [ProfileSetUpScreen] widget.
  const ProfileSetUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<ProfileFormProvider>(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: colors.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileInfoText(
                    tellUs: S.of(context).tellUs,
                    whoYouAre: S.of(context).whoYouAre,
                    andWellTake: S.of(context).andWellTake,
                  ),
                  const SizedBox(height: 24),
                  // OrangeTextForm(
                  //   nameButton: S.of(context).name,
                  //   icon: Icons.person,
                  //   controller: formProvider.nameController,
                  //   validator: formProvider.validateName,
                  // ),
                  InterviewTextField(
                    nameButton: S.of(context).name,
                    hintText: 'Nome Completo',
                    icon: CupertinoIcons.person_alt,
                    controller: formProvider.nameController,
                    validator: formProvider.validateName,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 8),
                  InterviewTextFieldBox(
                    nameButton: S.of(context).bio,
                    hintText: S.of(context).bioDescription,
                    icon: Icons.email_outlined,
                    controller: formProvider.bioController,
                    validator: formProvider.validateBio,
                    keyboardType: TextInputType.text
                  ),
                  const SizedBox(height: 8),
                  CupertinoDatePickerFieldd(
                    label: 'Data de Inicío',
                    fontSize: 12,
                    icon: Icons.calendar_today_outlined,
                    mode: DatePickerMode.futureOnly,
                    controller:
                    formProvider.dateOfBirthController,
                    validator:
                    formProvider.validateDateOfBirth,
                  ),
                  const SizedBox(height: 8),
                  BuildDropdownform(
                    label: S.of(context).gender,
                    items: ['Masculino', 'Feminino', 'Outro'],
                    icon: CupertinoIcons.person_solid,
                    validator: formProvider.validateGender,
                    onChanged: (value) =>
                    formProvider.gender = value,
                  ),
                  const SizedBox(height: 8),
                  InterviewTextField(
                    nameButton: S.of(context).jobTitle,
                    hintText: 'Cargo',
                    icon: CupertinoIcons.hammer,
                    controller: formProvider.jobTitleController,
                    validator: formProvider.validateJobTitle,
                    keyboardType: TextInputType.text,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(22),
        child: ContinueButton(
          title: S.of(context).continueButton,
          pathRoute: '/homeScreen',
          formKey: formKey,
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return AppBar(
      backgroundColor: colors.primary,
      foregroundColor: colors.secondary,
      centerTitle: true,
      toolbarHeight: 80,
      title: Text(
        S.of(context).profile,
        style: TextStyle(
          color: colors.tertiary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 30),
        onPressed: () {
          Navigator.pushNamed(context, '/getStarted');
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme(
              isOn: !Provider.of<ThemeProvider>(
                context,
                listen: false,
              ).isDarkMode,
            );
          },
          icon: const Icon(Icons.light_mode, size: 25),
        ),
      ],
    );
  }
}
