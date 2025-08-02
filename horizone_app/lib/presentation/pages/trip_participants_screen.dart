import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../state/interview_provider.dart';
import '../theme_color/app_colors.dart';
import '../widgets/bottom_actions.dart';
import '../widgets/participant_card.dart';

/// Screen responsible for displaying and collecting information
/// about the trip participants.
class TripParticipantsScreen extends StatefulWidget {
  /// Creates a [TripParticipantsScreen] widget.
  const TripParticipantsScreen({super.key});

  @override
  State<TripParticipantsScreen> createState() => _TripParticipantsScreenState();
}

/// State class for [TripParticipantsScreen], handles the layout
/// and rendering of the participant cards.
class _TripParticipantsScreenState extends State<TripParticipantsScreen> {
  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<InterviewProvider>(context);
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        toolbarHeight: 65,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'PARTICIPANTES',
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.secondary,
          ),
        ),
      ),
      body: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: interviewProvider.participants,
                itemBuilder: (_, index) {
                  return ParticipantCard(index: index);
                },
                padding: const EdgeInsets.only(
                  bottom: 70.0,
                  left: 8.0,
                  right: 8.0,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BottomActions(
        onPressed: () {
          Navigator.of(context).pushNamed('/tripStops');
        },
      ),
    );
  }
}
