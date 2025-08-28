import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../state/travelstops_provider.dart';
import '../theme_color/app_colors.dart';
import '../widgets/interview_widgets/interview_fab.dart';
import '../widgets/interview_widgets/interview_form_card.dart';
import '../widgets/interview_widgets/travelstops_widgets/add_stop_button.dart';
import '../widgets/interview_widgets/travelstops_widgets/intermediate_stops_section.dart';
import '../widgets/interview_widgets/travelstops_widgets/map_preview_card.dart';
import '../widgets/interview_widgets/travel_route_card.dart';
import '../widgets/section_title.dart';

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
    final stopsProvider = context.watch<TravelStopsProvider>();

    final middleCount = stopsProvider.stops.length;

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
              SectionTitle(
                title: 'Informações Gerais',
                icon: HugeIcons.strokeRoundedInformationCircle,
              ),
              SizedBox(height: 12),
              InterviewFormCard(),
              const SizedBox(height: 36),
              SectionTitle(title: 'Rota', icon: HugeIcons.strokeRoundedRoute01),
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
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
      floatingActionButton: InterviewFab(
        nameButton: 'Avançar',
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            if (!context.mounted) return;
            await Navigator.pushNamed(context, '/tripParticipants');
          }
        },
      ),
    );
  }
}
