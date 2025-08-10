import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/participant_provider.dart';
import '../save_participant_content.dart';
import '../update_participant_content.dart';

class UpdateParticipantModal extends StatefulWidget {
  const UpdateParticipantModal({super.key, required this.indexParticipant});

  final int indexParticipant;

  @override
  State<UpdateParticipantModal> createState() => _UpdateParticipantModalState();
}

class _UpdateParticipantModalState extends State<UpdateParticipantModal> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: const Duration(milliseconds: 150),
      child: UpdateParticipantContent(
        indexParticipant: widget.indexParticipant,
      ),
    );
  }
}
