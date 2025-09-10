import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/entities/participant.dart';
import '../../../../state/participant_provider.dart';
import '../../../../theme_color/app_colors.dart';
import '../participant_avatar_picker.dart';
import '../participant_form.dart';
import '../participant_handle_bar.dart';
import '../participant_modal_buttons.dart';
import '../participant_modal_header.dart';

/// A widget that displays the content of the save participant modal.
class SaveParticipantModal extends StatefulWidget {
  /// Creates an [SaveParticipantModal].
  const SaveParticipantModal({super.key});

  @override
  State<SaveParticipantModal> createState() => _SaveParticipantModalState();
}

class _SaveParticipantModalState extends State<SaveParticipantModal> {
  @override
  void initState() {
    super.initState();
    final participantProvider = Provider.of<ParticipantProvider>(
      context,
      listen: false,
    );
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

/// A widget that displays the content of the save participant modal.
class SaveParticipantContent extends StatefulWidget {
  /// Creates an [SaveParticipantContent].
  const SaveParticipantContent({super.key});

  @override
  State<SaveParticipantContent> createState() => _SaveParticipantContentState();
}

class _SaveParticipantContentState extends State<SaveParticipantContent> {
  final formKey = GlobalKey<FormState>();
  File? selectedImage;

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
                  title: 'Novo Integrante',
                  subtitle: 'Adicione um novo membro à viagem',
                  icon: HugeIcons.strokeRoundedUserAdd01,
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
                const SizedBox(height: 12),                ParticipantModalButtons(
                  actionLabel: 'Adicionar',
                  onCancel: () => Navigator.pop(context),
                  onConfirm: () {
                    if (formKey.currentState!.validate()) {
                      final participant = Participant(
                        name: participantProvider.nameController.text,
                        email: participantProvider.emailController.text,
                        photo: selectedImage,
                      );
                      participantProvider.addParticipant(participant);
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
