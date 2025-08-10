
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/participant_provider.dart';
import '../save_participant_content.dart';

class SaveParticipantModal extends StatefulWidget {
  const SaveParticipantModal({super.key});

  @override
  State<SaveParticipantModal> createState() => _SaveParticipantModalState();
}

class _SaveParticipantModalState extends State<SaveParticipantModal> {

  @override
  void initState() {
    super.initState();
    final participantProvider = Provider.of<ParticipantProvider>(context, listen: false);
    participantProvider.clearFields();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: const Duration(milliseconds: 150),
      child: const SaveParticipantContent(),
    );
  }
}
