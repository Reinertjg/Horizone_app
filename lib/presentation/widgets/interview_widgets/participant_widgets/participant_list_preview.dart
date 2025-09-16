import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import '../../../../generated/l10n.dart';
import '../../../state/participant_provider.dart';
import '../../../theme_color/app_colors.dart';
import '../../bottom_sheet_widgets/save_participant_modal.dart';
import 'options_participant_modal.dart';

/// A widget that displays a list of participants.
class ParticipantListPreview extends StatelessWidget {
  /// Creates a custom [ParticipantListPreview].
  const ParticipantListPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final participantProvider = Provider.of<ParticipantProvider>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 80,
        child: Row(
          children: [
            addParticipantClipOval(context),
            ListView.builder(
              itemCount: participantProvider.participants.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final participant = participantProvider.participants[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              OptionsParticipantModal(participant: participant),
                        );
                      },
                      child: Container(
                        width: 55,
                        height: 55,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: colors.quinary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.secondary.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: participant.photo == null
                              ? Image.asset(
                                  'assets/images/user_default_photo.png',
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  participant.photo!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 55,
                      child: Center(
                        child: Text(
                          participant.name,
                          style: TextStyle(color: colors.quaternary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that adds a participant to the list.
Widget addParticipantClipOval(BuildContext context) {
  final colors = Theme.of(context).extension<AppColors>()!;
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const SaveParticipantModal(),
                );
              },
              child: Container(
                width: 55,
                height: 55,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: colors.quinary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.secondary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedUserAdd01,
                    color: colors.secondary,
                  ),
                ),
              ),
            ),
            Text(S.of(context).add, style: TextStyle(color: colors.quaternary)),
          ],
        ),
      ],
    ),
  );
}
