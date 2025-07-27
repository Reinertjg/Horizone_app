import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_color/AppColors.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../database/daos/profile_dao.dart';
import '../../domain/usecases/profile_usecase.dart';
import '../state/profileform_provider.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    required this.title,
    required this.pathRoute,
    required this.formKey,
    super.key,
  });

  final String title;
  final String pathRoute;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<ProfileFormProvider>(context);
    final colors = Theme.of(context).extension<AppColors>()!;

    return ElevatedButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          final profile = formProvider.toEntity();

          final dao = ProfileDao();
          final repository = ProfileRepositoryImpl(dao);
          final useCase = ProfileUseCase(repository);

          await useCase.insert(profile);

          final getProfile = await ProfileDao().getProfile();
          print(getProfile);
          if (context.mounted) {
            Navigator.pushNamed(context, pathRoute);
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
