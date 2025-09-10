import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../domain/usecases/participant_usecase.dart';
import '../../domain/usecases/stop_usecase.dart';
import '../../domain/usecases/travel_usecase.dart';
import '../../repositories/participant_repository_impl.dart';
import '../../repositories/stop_repository_impl.dart';
import '../../repositories/travel_repository_impl.dart';
import '../../util/show_app_snackbar.dart';
import '../state/participant_provider.dart';
import '../state/stop_provider.dart';
import '../state/travel_provider.dart';
import '../theme_color/app_colors.dart';
import '../widgets/iconbutton_settings.dart';
import '../widgets/interview_widgets/blinking_dot.dart';
import '../widgets/interview_widgets/interview_fab.dart';
import '../widgets/interview_widgets/interview_form_card.dart';
import '../widgets/interview_widgets/map_preview_card.dart';
import '../widgets/interview_widgets/participant_widgets/participant_avatar_picker.dart';
import '../widgets/interview_widgets/travel_route_card.dart';
import '../widgets/interview_widgets/travelstops_widgets/add_stop_button.dart';
import '../widgets/interview_widgets/travelstops_widgets/intermediate_stops_section.dart';
import '../widgets/section_title.dart';
import 'home_screen.dart';

/// Section containing general information about the trip.
/// Includes title, start and end dates, transportation, and experience type.
class InterviewScreen extends StatefulWidget {
  /// Creates a custom [InterviewScreen].
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final travelProvider = Provider.of<TravelProvider>(context);
    final participantProvider = Provider.of<ParticipantProvider>(context);
    final stopProvider = Provider.of<StopProvider>(context);
    return Scaffold(
      backgroundColor: colors.primary,
      appBar: const _InterviewAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionTitle(
                title: 'Informações Gerais',
                icon: HugeIcons.strokeRoundedInformationCircle,
              ),
              SizedBox(height: 12),
              InterviewFormCard(),
              const SizedBox(height: 36),
              SectionTitle(title: 'Rota', icon: HugeIcons.strokeRoundedRoute02),
              const SizedBox(height: 16),
              TravelRouteCard(
                labelStart: 'Local Origem',
                labelEnd: 'Local Destino',
              ),
              const SizedBox(height: 16),
              MapPreviewCard(),
              const SizedBox(height: 16),
              IntermediateStopsSection(),
              const SizedBox(height: 16),
              AddStopButton(),
              const SizedBox(height: 20),
              _MiddleSection(),
              const SizedBox(height: 20),
              InterviewFab(
                nameButton: 'Avançar',
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // Save travel data
                    final travel = travelProvider.toEntity(
                      participantProvider.participants.length,
                      stopProvider.stops.length,
                    );

                    final travelUseCase = TravelUseCase(TravelRepositoryImpl());
                    final isOverlapping = travelUseCase.validateOverlap(
                      DateFormat('dd/MM/yyyy').parse(travel.startDate),
                      DateFormat('dd/MM/yyyy').parse(travel.endDate),
                    );

                    if (await isOverlapping) {
                      showAppSnackbar(
                        context: context,
                        snackbarMode: SnackbarMode.error,
                        iconData: HugeIcons.strokeRoundedAlert01,
                        message: 'Já existe uma viagem neste período.',
                      );
                    } else {
                      final travelId = await TravelUseCase(
                        TravelRepositoryImpl(),
                      ).insert(travel);

                      // Save participants data
                      final participants = participantProvider.toEntity(
                        travelId,
                      );
                      await ParticipantUseCase(
                        ParticipantRepositoryImpl(),
                      ).insert(participants);

                      // Save stops data
                      final stops = stopProvider.toEntity(travelId);
                      await StopUseCase(StopRepositoryImpl()).insert(stops);

                      showAppSnackbar(
                        context: context,
                        snackbarMode: SnackbarMode.success,
                        iconData: HugeIcons.strokeRoundedTick02,
                        message: 'Viagem criada com sucesso!',
                      );

                      travelProvider.reset();
                      participantProvider.reset();
                      stopProvider.reset();

                      if (!context.mounted) return;
                      await Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiddleSection extends StatelessWidget {
  const _MiddleSection();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.quaternary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.quaternary.withValues(alpha: 0.1)),
      ),
    );
  }
}

class _InterviewAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _InterviewAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return AppBar(
      backgroundColor: colors.primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        S.of(context).planningTravel,
        style: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colors.secondary,
        ),
      ),
      actions: [
        _IconButtonImage(),
        const SizedBox(width: 6),
        IconbuttonSettings(),
        const SizedBox(width: 12),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _IconButtonImage extends StatelessWidget {
  const _IconButtonImage();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Card(
      color: colors.quinary,
      shape: CircleBorder(),
      elevation: 2,
      child: SizedBox(
        height: 38,
        width: 38,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            HugeIcons.strokeRoundedImageAdd01,
            color: colors.quaternary,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => _TravelImageModal(),
            );
          },
        ),
      ),
    );
  }
}

class _TravelImageModal extends StatefulWidget {
  const _TravelImageModal();

  @override
  State<_TravelImageModal> createState() => _TravelImageModalState();
}

class _TravelImageModalState extends State<_TravelImageModal> {

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final travelProvider = Provider.of<TravelProvider>(context);
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
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: colors.quaternary.withAlpha(80),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colors.secondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          HugeIcons.strokeRoundedCameraAdd03,
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
                              'Adicionar imagem',
                              style: GoogleFonts.raleway(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: colors.quaternary,
                              ),
                            ),
                            Text(
                              'Adicione uma imagem para o seu cartão de viagem',
                              style: GoogleFonts.raleway(
                                fontSize: 14,
                                color: colors.quaternary.withValues(alpha: 0.5),
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  /// Travel cards - Sera implementado em um widget separado
                  Stack(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Card(
                            elevation: 2,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            color: colors.quinary,
                            child: travelProvider.getImage == null
                                ? Image.asset(
                              'assets/images/travel_default_photo.png',
                              fit: BoxFit.cover,
                            )
                                : Image.file(
                              travelProvider.getImage!,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,

                              /// Animated image loading
                              frameBuilder:
                                  (context, child, frame, wasSyncLoaded) {
                                if (wasSyncLoaded || frame != null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                        colors.tertiary,
                                      ),
                                      strokeWidth: 3.0,
                                    ),
                                  );
                                }
                              },

                              /// Error image loading
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/travel_default_photo.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 18,
                        left: 15,
                        child: Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              BlinkingDot(),
                              SizedBox(width: 6),
                              Text(
                                "Em andamento",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 15,
                        child: Icon(
                          CupertinoIcons.arrow_up_right_square_fill,
                          color: colors.quinary,
                          size: 25,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        left: 10,
                        child: Container(
                          width: 50,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                            color: colors.quaternary.withValues(alpha: 0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 16.0,
                              left: 16.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Viagem Familia Souza',
                                  style: GoogleFonts.raleway(
                                    color: colors.quinary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      HugeIcons.strokeRoundedLocation06,
                                      color: colors.quinary,
                                      size: 10,
                                    ),
                                    SizedBox(width: 2),
                                    Expanded(
                                      child: Text(
                                        'Florida - Orlando',
                                        style: GoogleFonts.raleway(
                                          color: colors.quinary,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: colors.tertiary,
                                      size: 16,
                                    ),
                                    SizedBox(width: 2),
                                    Icon(
                                      Icons.star_rounded,
                                      color: colors.tertiary,
                                      size: 16,
                                    ),
                                    SizedBox(width: 2),
                                    Icon(
                                      Icons.star_rounded,
                                      color: colors.tertiary,
                                      size: 16,
                                    ),
                                    SizedBox(width: 2),
                                    Icon(
                                      Icons.star_rounded,
                                      color: colors.tertiary,
                                      size: 16,
                                    ),
                                    SizedBox(width: 2),
                                    Icon(
                                      Icons.star_outline_rounded,
                                      color: colors.tertiary,
                                      size: 16,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      '4.6',
                                      style: GoogleFonts.nunito(
                                        color: colors.quinary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Example of the added image',
                    style: GoogleFonts.raleway(
                      fontSize: 14,
                      color: colors.quaternary.withAlpha(100),
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

                  /// Image options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ImageOption(
                        icon: CupertinoIcons.photo_camera_solid,

                        label: 'Câmera',
                        onTap: () {
                          context.read<TravelProvider>().pickImage(
                            OptionPhotoMode.cameraMode,
                          );
                        },
                        backgroundColor: colors.secondary.withAlpha(50),
                        iconColor: colors.secondary,
                      ),
                      _ImageOption(
                        icon: HugeIcons.strokeRoundedAlbum01,
                        label: 'Galeria',
                        onTap: () {
                          context.read<TravelProvider>().pickImage(
                            OptionPhotoMode.galleryMode,
                          );
                        },
                        backgroundColor: colors.tertiary.withAlpha(50),
                        iconColor: colors.tertiary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  const _ImageOption({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
