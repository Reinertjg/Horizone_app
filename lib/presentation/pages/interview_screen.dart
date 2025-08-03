import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:google_fonts/google_fonts.dart';

import '../../generated/l10n.dart';
import '../theme_color/app_colors.dart';
import '../widgets/interview_widgets/interview_fab.dart';
import '../widgets/interview_widgets/interview_form_card.dart';
import '../widgets/participant_card.dart';
import '../widgets/profile_widgets/bottom_navigationbar.dart';
import '../widgets/section_title.dart';

/// Screen where the user fills out general travel information
/// as part of the trip planning flow.
class InterviewScreen extends StatefulWidget {
  /// Creates an [InterviewScreen] widget.
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

/// State class for [InterviewScreen]
/// Responsible for form management and layout.
class _InterviewScreenState extends State<InterviewScreen> {
  /// Global form key used to validate and manage form state.
  final formKey = GlobalKey<FormState>();

  /// Current quantity of participants or related value (if applicable).
  int qtd = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          S.of(context).planningTravel,
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.secondary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    SectionTitle(
                      title: 'Informações Gerais',
                      icon: Icons.info_outline,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                InterviewFormCard(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: InterviewFab(
        nameButton: 'Avançar',
        onPressed: () async {
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
          }
        },
      ),
    );
  }
}
