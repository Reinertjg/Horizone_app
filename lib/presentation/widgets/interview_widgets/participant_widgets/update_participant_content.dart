import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/entities/participant.dart';
import '../../../state/participant_provider.dart';
import '../../../theme_color/app_colors.dart';
import 'participant_avatar_picker.dart';
import 'participant_form.dart';
import 'participant_handle_bar.dart';
import 'participant_modal_buttons.dart';
import 'participant_modal_header.dart';

class UpdateParticipantContent extends StatefulWidget {
  const UpdateParticipantContent({super.key, required this.indexParticipant});

  final int indexParticipant;

  @override
  State<UpdateParticipantContent> createState() =>
      _UpdateParticipantContentState();
}

class _UpdateParticipantContentState extends State<UpdateParticipantContent> {
  final formKey = GlobalKey<FormState>();
  File? selectedImage;

  @override
  void initState() {
    final participantProvider = Provider.of<ParticipantProvider>(
      context,
      listen: false,
    );
    participantProvider.nameController.text =
        participantProvider.participants[widget.indexParticipant].name;
    participantProvider.emailController.text =
        participantProvider.participants[widget.indexParticipant].email;
    selectedImage =
        participantProvider.participants[widget.indexParticipant].photo;
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
                        widget.indexParticipant,
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
