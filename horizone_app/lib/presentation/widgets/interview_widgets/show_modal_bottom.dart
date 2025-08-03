import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/participant.dart';
import '../../state/participant_provider.dart';
import '../../theme_color/app_colors.dart';
import '../orange_text_form.dart';
import 'interview_fab.dart';

void showAddMemberModal(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: true,
    isDismissible: true,
    builder: (BuildContext context) {
      final colors = Theme.of(context).extension<AppColors>()!;
      final participantProvider = Provider.of<ParticipantProvider>(context);

      return StatefulBuilder(
        builder: (context, setState) {
          return AnimatedPadding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            duration: const Duration(milliseconds: 150),
            child: Container(
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
                    maxHeight:
                        MediaQuery.of(context).size.height *
                        0.85, // limite de altura
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Handle bar
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: colors.quaternary.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: colors.secondary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.person_add_rounded,
                                color: colors.secondary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Novo Integrante',
                                    style: GoogleFonts.raleway(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: colors.quaternary,
                                    ),
                                  ),
                                  Text(
                                    'Adicione um novo membro à viagem',
                                    style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      color: colors.quaternary.withValues(
                                        alpha: 0.5,
                                      ),
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        //
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Implemented Image Picker
                              _showImagePickerOptions(context);
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: colors.quinary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colors.secondary.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: 40,
                                color: colors.secondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Toque para adicionar foto',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              color: colors.quaternary.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Form
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              OrangeTextForm(
                                nameButton: 'Nome completo',
                                icon: Icons.person_outline_rounded,
                                controller: participantProvider.nameController,
                                validator: participantProvider.validateName,
                              ),
                              const SizedBox(height: 24),
                              OrangeTextForm(
                                nameButton: 'E-mail',
                                icon: Icons.person_outline_rounded,
                                controller: participantProvider.emailController,
                                validator: participantProvider.validateEmail,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Buttons
                        Row(
                          children: [
                            // Cancel Button
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: colors.quaternary.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                  ),
                                  foregroundColor: colors.quaternary.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                                child: Text(
                                  'Cancelar',
                                  style: GoogleFonts.raleway(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Add Button
                            Expanded(
                              flex: 2,
                              child: InterviewFab(
                                nameButton: 'Adicionar Integrante',
                                onPressed: () {
                                  if (participantProvider.validateAll(
                                    formKey,
                                  )) {
                                    participantProvider.addParticipant(
                                      Participant(
                                        name: participantProvider
                                            .nameController
                                            .text,
                                        email: participantProvider
                                            .emailController
                                            .text,
                                      ),
                                    );
                                    participantProvider.clearFields();
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void _showImagePickerOptions(BuildContext context) {
  final colors = Theme.of(context).extension<AppColors>()!;
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: DefaultTextStyle(
            style: GoogleFonts.raleway(color: colors.quaternary),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.quaternary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Selecionar foto',
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Câmera
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Implementar pick da câmera
                        // ImagePicker().pickImage(source: ImageSource.camera);
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colors.secondary.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 32,
                              color: colors.secondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Câmera',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Galeria
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Implementar pick da galeria
                        // ImagePicker().pickImage(source: ImageSource.gallery);
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colors.tertiary.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.photo_library_outlined,
                              size: 32,
                              color: colors.tertiary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Galeria',
                            style: GoogleFonts.raleway(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    },
  );
}
