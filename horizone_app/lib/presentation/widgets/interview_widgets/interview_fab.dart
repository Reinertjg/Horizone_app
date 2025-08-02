import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../state/interview_provider.dart';
import '../../theme_color/app_colors.dart';

/// Builds the FAB widget used to validate the form
/// Navigate to the next screen.
class InterviewFab extends StatelessWidget {
  /// Creates a custom [InterviewFab] with the given parameter.
  const InterviewFab({super.key, required this.formKey});

  /// The [GlobalKey] for the form.
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final interviewProvider = Provider.of<InterviewProvider>(context);
    return Container(
      height: 45,
      width: MediaQuery
          .of(context)
          .size
          .width * 0.9,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.secondary, Colors.lightBlueAccent],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        onPressed: () async {
          // final travels = await TripDao().getAllTrips();
          // print(travels);

          if (formKey.currentState!.validate()) {
            if (!context.mounted) return;

            await Navigator.pushNamed(context, '/tripParticipants');

            // final interview = interviewProvider.toEntity();
            //
            // final dao = TripDao();
            // final repository = TripRepositoryImpl(dao);
            // final useCase = InterviewUseCase(repository);
            //
            // await useCase.insert(interview);
            interviewProvider.participants =
              int.parse(interviewProvider.numberOfParticipantsController.text);

          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          'Avançar',
          style: GoogleFonts.raleway(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
