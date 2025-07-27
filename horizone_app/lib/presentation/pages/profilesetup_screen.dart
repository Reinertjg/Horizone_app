import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:provider/provider.dart';
import '../../../generated/l10n.dart';
import '../../AppColors.dart';
import '../state/profileform_provider.dart';
import '../state/theme_provider.dart';
import '../widgets/date_picker_text_form_field.dart';
import '../widgets/orange_dropdownform.dart';
import '../widgets/profile_info_text.dart';
import '../widgets/orange_text_form.dart';
import '../widgets/orange_text_box_form.dart';
import '../widgets/continue_button.dart';

class ProfileSetUpScreen extends StatelessWidget {
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
                  OrangeTextForm(
                    nameButton: S.of(context).name,
                    icon: Icons.person,
                    controller: formProvider.nameController,
                    validator: formProvider.validateName,
                  ),
                  const SizedBox(height: 18),
                  OrangeTextBoxForm(
                    nameButton: S.of(context).bio,
                    hintText: S.of(context).bioDescription,
                    icon: Icons.info_outline,
                    controller: formProvider.bioController,
                    validator: formProvider.validateBio,
                  ),
                  const SizedBox(height: 18),
                  CupertinoDatePickerField(
                    label: S.of(context).dateOfBirth,
                    fontSize: 16,
                    mode: DatePickerMode.birthdate,
                    icon: Icons.calendar_today_outlined,
                    controller: formProvider.dateOfBirthController,
                    validator: formProvider.validateDateOfBirth,
                  ),
                  const SizedBox(height: 18),
                  OrangeDropdownform(
                    label: S.of(context).gender,
                    items: ['Masculino', 'Feminino', 'Outro'],
                    icon: Icons.person_outline,
                    validator: formProvider.validateGender,
                    onChanged: formProvider.setGender,
                  ),
                  const SizedBox(height: 18),
                  OrangeTextForm(
                    nameButton: S.of(context).jobTitle,
                    icon: Icons.work_outline,
                    controller: formProvider.jobTitleController,
                    validator: formProvider.validateJobTitle,
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
          pathRoute: "/dashboard",
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
              !Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            );
          },
          icon: const Icon(Icons.light_mode, size: 25),
        ),
      ],
    );
  }
}
