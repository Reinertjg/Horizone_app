import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/usecases/profile_usecase.dart';
import '../../repositories/profile_repository_impl.dart';
import '../state/profile_provider.dart';
import '../theme_color/app_colors.dart';

/// A reusable button widget that validates a form,
/// persists the profile data, and navigates to the given route.
class ContinueButton extends StatelessWidget {
  /// Creates a [ContinueButton].
  ///
  /// [title] is the text shown on the button,
  /// [pathRoute] is the named route to navigate to on success,
  /// [formKey] is used for form validation.
  const ContinueButton({
    required this.title,
    required this.pathRoute,
    required this.formKey,
    super.key,
  });

  /// Text to display on the button.
  final String title;

  /// Route to navigate to after successful validation and saving.
  final String pathRoute;

  /// Key to validate the associated form.
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<ProfileProvider>(context);
    final colors = Theme.of(context).extension<AppColors>()!;

    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          final profile = formProvider.toEntity();

          final repository = ProfileRepositoryImpl();
          final useCase = ProfileUseCase(repository);

          await useCase.insert(profile);

          if (context.mounted) {
            await Navigator.pushNamed(context, pathRoute);
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.secondary,
        padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 12),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
