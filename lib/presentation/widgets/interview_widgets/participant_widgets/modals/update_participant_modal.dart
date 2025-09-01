import 'package:flutter/material.dart';

import '../../../../../domain/entities/participant.dart';
import '../update_participant_content.dart';

/// A modal widget for updating a [Participant].
class UpdateParticipantModal extends StatefulWidget {
  /// Creates a custom [UpdateParticipantModal].
  const UpdateParticipantModal({super.key, required this.participant});

  /// The participant to be updated.
  final Participant participant;

  @override
  State<UpdateParticipantModal> createState() => _UpdateParticipantModalState();
}

/// The state for [UpdateParticipantModal].
class _UpdateParticipantModalState extends State<UpdateParticipantModal> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: const Duration(milliseconds: 150),
      child: UpdateParticipantContent(
        participant: widget.participant,
      ),
    );
  }
}
