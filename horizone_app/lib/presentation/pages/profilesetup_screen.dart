import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../generated/l10n.dart';
import '../state/theme_provider.dart';
import '../widgets/profile_info_text.dart';
import '../widgets/orange_text_form.dart';
import '../widgets/orange_text_box_form.dart';
import '../widgets/date_picker_text_form_field.dart';
import '../widgets/continue_button.dart';

class ProfileSetUpScreen extends StatelessWidget {
  const ProfileSetUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileInfoText(
                  tellUs: S.of(context).tellUs,
                  whoYouAre: S.of(context).whoYouAre,
                  andWellTake: S.of(context).andWellTake,
                ),
                const SizedBox(height: 24),
                OrangeTextForm(nameButton: S.of(context).name, icon: Icons.person),
                const SizedBox(height: 18),
                OrangeTextBoxForm(
                  nameButton: S.of(context).bio,
                  hintText: S.of(context).bioDescription,
                  icon: Icons.info_outline,
                ),
                const SizedBox(height: 18),
                DatePickerTextFormField(nameButton: S.of(context).dateOfBirth),
                const SizedBox(height: 18),
                OrangeTextForm(nameButton: S.of(context).gender, icon: Icons.person_outline),
                const SizedBox(height: 18),
                OrangeTextForm(nameButton: S.of(context).jobTitle, icon: Icons.work_outline),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(22),
        child: ContinueButton(
          title: S.of(context).continueButton,
          pathRoute: "/dashboard",
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: Theme.of(context).primaryColor,
      centerTitle: true,
      toolbarHeight: 80,
      title: Text(
        S.of(context).profile,
        style: TextStyle(
          color: Theme.of(context).hintColor,
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
            Provider.of<ThemeProvider>(context, listen: false)
                .toggleTheme(!Provider.of<ThemeProvider>(context, listen: false).isDarkMode);
          },
          icon: const Icon(Icons.light_mode, size: 25),
        )
      ],
    );
  }
}
