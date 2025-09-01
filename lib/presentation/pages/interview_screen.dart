import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../data/repositories/travel_repository_impl.dart';
import '../../domain/usecases/travel_usecase.dart';
import '../state/interview_provider.dart';
import '../state/participant_provider.dart';
import '../theme_color/app_colors.dart';
import '../widgets/interview_widgets/interview_fab.dart';
import '../widgets/interview_widgets/interview_form_card.dart';
import '../widgets/interview_widgets/travel_route_card.dart';
import '../widgets/interview_widgets/travelstops_widgets/add_stop_button.dart';
import '../widgets/interview_widgets/travelstops_widgets/intermediate_stops_section.dart';
import '../widgets/interview_widgets/map_preview_card.dart';
import '../widgets/section_title.dart';
import 'home_screen.dart';

/// Section containing general information about the trip.
/// Includes title, start and end dates, transportation, and experience type.
class InterviewScreen extends StatefulWidget {
  /// Creates a custom [InterviewScreen].
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final formTravel = Provider.of<InterviewProvider>(context);
    final participantProvider = Provider.of<ParticipantProvider>(context);
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
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _UpdateTravelImage(),
              SectionTitle(
                title: 'Informações Gerais',
                icon: HugeIcons.strokeRoundedInformationCircle,
              ),
              SizedBox(height: 12),
              InterviewFormCard(),
              const SizedBox(height: 36),
              SectionTitle(title: 'Rota', icon: HugeIcons.strokeRoundedRoute02),
              const SizedBox(height: 16),
              TravelRouteCard(
                labelStart: 'Local Origem',
                labelEnd: 'Local Destino',
              ),
              const SizedBox(height: 16),
              MapPreviewCard(),
              const SizedBox(height: 16),
              IntermediateStopsSection(),
              const SizedBox(height: 16),
              AddStopButton(),
              const SizedBox(height: 20),
              _buildMiddleSection(context),
              const SizedBox(height: 20),
              InterviewFab(
                nameButton: 'Avançar',
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final travel = formTravel.toEntity(
                      participantProvider.participants.length,
                    );

                    final repository = TravelRepositoryImpl();
                    final useCase = TravelUseCase(repository);

                    await useCase.insert(travel);

                    if (!context.mounted) return;
                    await Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiddleSection(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.quaternary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.quaternary.withValues(alpha: 0.1)),
      ),
    );
  }
}

class _UpdateTravelImage extends StatelessWidget {
  const _UpdateTravelImage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            HugeIcons.strokeRoundedImage01,
            color: colors.secondary,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text('Alterar capa',
            style: GoogleFonts.raleway(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colors.secondary,
            ),
          )
        ]
    );
  }
}