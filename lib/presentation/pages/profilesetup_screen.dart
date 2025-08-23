import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:provider/provider.dart';

import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/profile_usecase.dart';
import '../../generated/l10n.dart';
import '../state/profileform_provider.dart';
import '../state/theme_provider.dart';
import '../theme_color/app_colors.dart';
import '../widgets/interview_widgets/build_dropdownform.dart';
import '../widgets/interview_widgets/interview_fab.dart';
import '../widgets/interview_widgets/interview_textfield.dart';
import '../widgets/interview_widgets/interview_textfield_box.dart';
import '../widgets/interview_widgets/test_cupertino_date_picker.dart';
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
    final formProvider = Provider.of<ProfileFormProvider>(context);
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: colors.primary,
      body: SingleChildScrollView(
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
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 8),
                CupertinoDatePickerField(
                  label: S.of(context).dateOfBirth,
                  fontSize: 12,
                  icon: Icons.calendar_today_outlined,
                  controller: formProvider.dateOfBirthController,
                  validator: formProvider.validateDateOfBirth,
                  maxDate: DateTime.now(),
                  minDate: DateTime(1900),
                  initialDate: DateTime.now(),
                ),
                const SizedBox(height: 8),
                BuildDropdownform(
                  label: S.of(context).gender,
                  items: ['Masculino', 'Feminino', 'Outro'],
                  icon: CupertinoIcons.person_solid,
                  validator: formProvider.validateGender,
                  onChanged: (value) => formProvider.gender = value,
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
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: InterviewFab(
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
