import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../theme_color/app_colors.dart';
import '../participant_widgets/modals/save_participant_modal.dart';

/// A button that opens a modal bottom sheet to add a participant.
class AddParticipantButton extends StatelessWidget {
  /// Creates a custom [AddParticipantButton].
  const AddParticipantButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const SaveParticipantModal(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Participantes',
            style: TextStyle(color: colors.quaternary),
          ),
          Icon(
            CupertinoIcons.delete,
            color: colors.secondary,
            size: 20,
          ),
        ],
      ),
    );
  }
}
