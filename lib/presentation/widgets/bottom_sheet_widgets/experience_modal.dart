import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../domain/usecases/experience_usecase.dart';
import '../../../repositories/experience_repository_impl.dart';
import '../../state/experience_provider.dart';
import '../../theme_color/app_colors.dart';
import '../interview_widgets/interview_textfield_box.dart';
import '../interview_widgets/participant_widgets/participant_avatar_picker.dart';
import '../interview_widgets/participant_widgets/participant_handle_bar.dart';
import '../interview_widgets/participant_widgets/participant_modal_buttons.dart';
import '../interview_widgets/participant_widgets/participant_modal_header.dart';
import '../show_dialog_image.dart';
import 'options_image_modal.dart';

/// Shows a modal bottom sheet allowing the user to create/update
/// an Experience for a given Stop.
Future<bool?> showExperienceStopBottomSheet(BuildContext context, int stopId) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => SaveExperienceModal(stopId: stopId),
  );
}

/// Bottom sheet widget that contains the Experience form for a specific Stop.
class SaveExperienceModal extends StatefulWidget {
  /// Creates a [SaveExperienceModal].
  const SaveExperienceModal({super.key, required this.stopId});

  /// The Stop identifier for which the Experience will be created/updated.
  final int stopId;

  @override
  State<SaveExperienceModal> createState() => _SaveExperienceModalState();
}

class _SaveExperienceModalState extends State<SaveExperienceModal> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      duration: const Duration(milliseconds: 150),
      child: ExperienceStopContent(stopId: widget.stopId),
    );
  }
}

/// The content of the Experience form: description + up to three photos.
class ExperienceStopContent extends StatefulWidget {
  /// Creates an [ExperienceStopContent].
  const ExperienceStopContent({super.key, required this.stopId});

  /// The Stop identifier for which the Experience belongs.
  final int stopId;

  @override
  State<ExperienceStopContent> createState() => _ExperienceStopContentState();
}

class _ExperienceStopContentState extends State<ExperienceStopContent> {
  final TextEditingController _reportController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// When `true`, empty photo cards display a red border and
  /// an inline error text is shown below the row of photo cards.
  bool _photosError = false;

  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final experienceProvider = Provider.of<ExperienceProvider>(context);
    final errorColor = Theme.of(context).colorScheme.error;

    if (_photosError && experienceProvider.imagesNotEmpty()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _photosError = false);
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.quaternary.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, -2),
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
                  title: 'Conte sua experiência',
                  subtitle:
                      'Descreva sua experiência, conte detalhes interessantes,'
                      ' momentos marcantes...',
                  icon: HugeIcons.strokeRoundedEdit01,
                ),
                const SizedBox(height: 16),

                /// Description field (validated via provider)
                Form(
                  key: _formKey,
                  child: InterviewTextFieldBox(
                    nameButton: 'Descrição',
                    hintText: 'Compartilhe seus pensamentos e memórias',
                    icon: HugeIcons.strokeRoundedTextIndent01,
                    controller: experienceProvider.descriptionController,
                    validator: experienceProvider.validateExperience,
                  ),
                ),

                const SizedBox(height: 16),

                /// Photo cards
                /// (red border on empty ones when _photosError = true)
                Row(
                  children: [
                    _PhotoCard(order: 1, showError: _photosError),
                    _PhotoCard(order: 2, showError: _photosError),
                    _PhotoCard(order: 3, showError: _photosError),
                  ],
                ),

                if (_photosError) ...[
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Adicione ao menos uma foto',
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: errorColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                /// Action buttons (Cancel / Save)
                ParticipantModalButtons(
                  actionLabel: 'Salvar',
                  onCancel: () => Navigator.pop(context, false),
                  onConfirm: () async {
                    FocusScope.of(context).unfocus();

                    // Validate description
                    final isValid = _formKey.currentState?.validate() ?? false;
                    if (!isValid) return;

                    // Validate at least one photo
                    if (!experienceProvider.imagesNotEmpty()) {
                      setState(() => _photosError = true);
                      return;
                    }

                    // Persist experience
                    final useCase = ExperienceUseCase(
                      ExperienceRepositoryImpl(),
                    );
                    await useCase.insertExperience(
                      experienceProvider.toEntity(widget.stopId),
                    );

                    if (!context.mounted) return;
                    Navigator.pop(context, true);
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

/// A single photo card used within the Experience form. It displays either:
/// - a placeholder prompting the user to add a photo; or
/// - the selected photo with a delete button.
/// When [showError] is true and the card is empty, its border becomes red.
class _PhotoCard extends StatefulWidget {
  /// Creates a photo card for the given [order] (1..3).
  const _PhotoCard({required this.order, required this.showError});

  /// The slot index (1, 2, or 3) this card represents.
  final int order;

  /// When true and no image is present, the card shows an error border color.
  final bool showError;

  @override
  State<_PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<_PhotoCard> {
  @override
  Widget build(BuildContext context) {
    final experienceProvider = Provider.of<ExperienceProvider>(context);
    final errorColor = Theme.of(context).colorScheme.error;

    final file = experienceProvider.images[widget.order - 1];
    final hasImage = file != null;
    final borderColor = (!hasImage && widget.showError)
        ? errorColor
        : Colors.grey.shade300;

    return Expanded(
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              // Close keyboard before opening sheet
              FocusManager.instance.primaryFocus?.unfocus();

              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => ImagePickerSheet(
                  title: 'Configurações',
                  onCameraTap: () async {
                    Navigator.pop(context);
                    await experienceProvider.pickImage(
                      OptionPhotoMode.cameraMode,
                      widget.order,
                    );
                  },
                  onVisualizeTap: () {
                    if (file != null) {
                      showDialogImage(context, file, MainAxisAlignment.start);
                    }
                  },
                  onGalleryTap: () async {
                    Navigator.pop(context);
                    await experienceProvider.pickImage(
                      OptionPhotoMode.galleryMode,
                      widget.order,
                    );
                  },
                ),
              );
            },
            child: hasImage
                ? Stack(
                    children: [
                      SizedBox.expand(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            file,
                            fit: BoxFit.cover,
                            frameBuilder: (context, child, frame, wasSync) {
                              if (wasSync) return child;
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                layoutBuilder:
                                    (currentChild, previousChildren) => Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ...previousChildren,
                                        if (currentChild != null) currentChild,
                                      ],
                                    ),
                                child: frame == null
                                    ? const SizedBox.expand(
                                        child: Center(
                                          child: SizedBox(
                                            width: 28,
                                            height: 28,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox.expand(child: child),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 1,
                        right: 1,
                        child: GestureDetector(
                          onTap: () {
                            experienceProvider.removePhoto(widget.order - 1);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedCameraAdd03,
                        size: 32,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Adicionar foto',
                        style: GoogleFonts.nunito(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
