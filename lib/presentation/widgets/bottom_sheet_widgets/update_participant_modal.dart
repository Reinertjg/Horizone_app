import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/participant.dart';
import '../../state/participant_provider.dart';
import '../../theme_color/app_colors.dart';
import '../interview_widgets/participant_widgets/participant_avatar_picker.dart';
import '../interview_widgets/participant_widgets/participant_form.dart';
import '../interview_widgets/participant_widgets/participant_handle_bar.dart';
import '../interview_widgets/participant_widgets/participant_modal_buttons.dart';
import '../interview_widgets/participant_widgets/participant_modal_header.dart';

/// Shows a bottom sheet for updating a [Participant].
/// Using in [OptionsParticipantModal].
void showUpdateParticipantModal(BuildContext context, Participant participant) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => UpdateParticipantModal(participant: participant),
  );
}

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
      child: _UpdateParticipantContent(participant: widget.participant),
    );
  }
}

/// A widget that displays the content of the update participant modal.
class _UpdateParticipantContent extends StatefulWidget {
  /// Creates an [_UpdateParticipantContent].
  const _UpdateParticipantContent({required this.participant});

  /// The participant being edited.
  final Participant participant;

  @override
  State<_UpdateParticipantContent> createState() =>
      _UpdateParticipantContentState();
}

class _UpdateParticipantContentState extends State<_UpdateParticipantContent> {
  final formKey = GlobalKey<FormState>();
  File? selectedImage;

  /// Updates the participant's data.
  void updateParticipant() {
    final participantProvider = Provider.of<ParticipantProvider>(
      context,
      listen: false,
    );
    participantProvider.nameController.text = widget.participant.name;
    participantProvider.emailController.text = widget.participant.email;
    selectedImage = widget.participant.photo;
  }

  @override
  void initState() {
    updateParticipant();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final participantProvider = Provider.of<ParticipantProvider>(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.quaternary.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const ParticipantHandleBar(),
                const SizedBox(height: 20),
                const ParticipantModalHeader(
                  title: 'Altere os dados',
                  subtitle: 'Altere os dados do integrante',
                  icon: HugeIcons.strokeRoundedEdit01,
                ),
                const SizedBox(height: 16),
                ParticipantAvatarPicker(
                  image: selectedImage,
                  onImagePicked: (file) => setState(() => selectedImage = file),
                ),
                ParticipantForm(
                  formKey: formKey,
                  nameController: participantProvider.nameController,
                  emailController: participantProvider.emailController,
                  validateName: participantProvider.validateName,
                  validateEmail: participantProvider.validateEmail,
                ),
                const SizedBox(height: 24),
                ParticipantModalButtons(
                  actionLabel: 'Alterar',
                  onCancel: () => Navigator.pop(context),
                  onConfirm: () {
                    if (formKey.currentState!.validate()) {
                      final participant = Participant(
                        name: participantProvider.nameController.text,
                        email: participantProvider.emailController.text,
                        photo: selectedImage,
                      );
                      participantProvider.updateParcipant(
                        widget.participant,
                        participant,
                      );
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
