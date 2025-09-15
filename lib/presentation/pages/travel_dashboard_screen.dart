import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../domain/entities/experience.dart';
import '../../domain/entities/participant.dart';
import '../../domain/entities/stop.dart';
import '../../domain/entities/travel.dart';
import '../../repositories/experience_repository_impl.dart';
import '../../repositories/participant_repository_impl.dart';
import '../../repositories/stop_repository_impl.dart';
import '../../util/date_utils.dart';
import '../../util/string_utils.dart';
import '../../util/travel_status.dart';
import '../pdf/pdf_generator.dart';
import '../theme_color/app_colors.dart';
import '../widgets/bottom_sheet_widgets/experience_modal.dart';
import '../widgets/dashboard_widgets/status_chip.dart';
import '../widgets/iconbutton_settings.dart';
import '../widgets/interview_widgets/interview_fab.dart';
import '../widgets/section_title.dart';

/// The dashboard screen for the travel details.
class TravelDashboardScreen extends StatefulWidget {
  /// Creates a [TravelDashboardScreen] widget.
  const TravelDashboardScreen({super.key, required this.travel});

  /// The travel to be displayed in the dashboard.
  final Travel travel;

  @override
  State<TravelDashboardScreen> createState() => _TravelDashboardScreenState();
}

class _TravelDashboardScreenState extends State<TravelDashboardScreen> {
  final repositoryParticipant = ParticipantRepositoryImpl();
  final repositoryStop = StopRepositoryImpl();
  final repositoryExperience = ExperienceRepositoryImpl();
  List<Participant> participants = [];
  List<Stop> stops = [];
  List<Experience> experiences = [];
  String currentLocation = '';
  String? currentLocationDate;

  /// Returns true if the travel is ongoing, false otherwise.
  bool _isTravelOngoing() {
    final status = getTravelStatus(
      startDate: parseTravelDate(widget.travel.startDate),
      endDate: parseTravelDate(widget.travel.endDate),
    );

    if (status == TravelStatus.inProgress) {
      return true;
    }

    return false;
  }

  /// Returns the color based on the status of the stop.
  Future<void> _uploadParticipants() async {
    try {
      final searched = await repositoryParticipant.getParticipantsByTravelId(
        widget.travel.id!,
      );
      setState(() {
        participants = searched;
        _determineCurrentLocation();
      });
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Returns the color based on the status of the stop.
  Future<void> _uploadStops() async {
    try {
      final searched = await repositoryStop.getStopsByTravelId(
        widget.travel.id!,
      );
      setState(() {
        stops = searched;
        _determineCurrentLocation();
      });
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> _uploadExperiences() async {
    try {
      final searched = await repositoryExperience.getAllExperiences();
      setState(() {
        experiences = searched;
      });
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Returns the color based on the status of the stop.
  void _determineCurrentLocation() {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final startDate = parseTravelDate(widget.travel.startDate);
    final startDateOnly = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final endDate = parseTravelDate(widget.travel.endDate);
    final endDateOnly = DateTime(endDate.year, endDate.month, endDate.day);

    currentLocation = widget.travel.originLabel;

    final currentStop = stops.where((stop) {
      final date = stop.startDate!;
      final stopOnly = DateTime(date.year, date.month, date.day);
      return stopOnly.isAtSameMomentAs(todayOnly);
    }).firstOrNull;

    if (currentStop != null) {
      currentLocation = currentStop.label;
      currentLocationDate = _formatStopShort(currentStop.startDate!);
    } else {
      if (todayOnly.isAtSameMomentAs(startDateOnly)) {
        currentLocation = widget.travel.originLabel;
        currentLocationDate = _formatStopShort(startDate);
      } else if (todayOnly.isAtSameMomentAs(endDateOnly)) {
        currentLocation = widget.travel.destinationLabel;
        currentLocationDate = _formatStopShort(endDate);
      } else {
        currentLocation = '';
        currentLocationDate = null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _uploadParticipants();
    _uploadStops();
    _uploadExperiences();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.primary,
      appBar: const _AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SectionTitle(
                title: widget.travel.title,
                icon: HugeIcons.strokeRoundedTextCircle,
              ),
            ),
            _TravelInfoCard(
              travel: widget.travel,
              status: getTravelStatus(
                startDate: parseTravelDate(widget.travel.startDate),
                endDate: parseTravelDate(widget.travel.endDate),
              ),
            ),

            if (participants.isNotEmpty)
              _ParticipantsList(participants: participants),

            if (_isTravelOngoing())
              _CurrentLocationCard(
                currentLocation: currentLocation,
                currentLocationDate: currentLocationDate,
              ),
            _TravelTimeline(travel: widget.travel, stops: stops),
            const SizedBox(height: 20),
            _BottomButtons(
              travel: widget.travel,
              participants: participants,
              stops: stops,
              experiences: experiences,
              onUploadExperience: _uploadExperiences,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return AppBar(
      backgroundColor: colors.primary,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: colors.secondary),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Detalhes da Viagem',
        style: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colors.secondary,
        ),
      ),
      actions: const [IconbuttonSettings(), SizedBox(width: 12)],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TravelInfoCard extends StatelessWidget {
  const _TravelInfoCard({required this.travel, required this.status});

  final Travel travel;
  final TravelStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final startDate = parseTravelDate(travel.startDate);
    final endDate = parseTravelDate(travel.endDate);
    final duration = endDate.difference(startDate).inDays + 1;
    final dateFormat = DateFormat('dd MMM yyyy', 'pt_BR');
    final formattedStartDate = dateFormat.format(startDate);
    final formattedEndDate = dateFormat.format(endDate);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.secondary,
            colors.secondary.withRed(102).withGreen(178).withBlue(255),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: colors.secondary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$formattedStartDate - $formattedEndDate',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$duration dias',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              StatusChip(status: status),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(
                Icons.group_outlined,
                color: Colors.white.withValues(alpha: 0.9),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${travel.numberOfParticipants} participantes',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.route_outlined,
                color: Colors.white.withValues(alpha: 0.9),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '${travel.numberOfStops} paradas',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CurrentLocationCard extends StatelessWidget {
  const _CurrentLocationCard({
    required this.currentLocation,
    this.currentLocationDate,
  });

  final String currentLocation;
  final String? currentLocationDate;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colors.secondary.withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.secondary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              HugeIcons.strokeRoundedLocation05,
              color: colors.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Localização Atual',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  currentLocation,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A1A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (currentLocationDate != null)
            Text(
              currentLocationDate!,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: colors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

class _TravelTimeline extends StatelessWidget {
  const _TravelTimeline({required this.travel, required this.stops});

  final Travel travel;
  final List<Stop> stops;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                HugeIcons.strokeRoundedRoute03,
                color: Colors.grey[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Roteiro da Viagem',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stops.length + 2,
            separatorBuilder: (context, index) => const _TimelineConnector(),
            itemBuilder: (context, index) {
              final isOrigin = index == 0;
              final isDestination = index == stops.length + 1;

              if (isOrigin) {
                final start = parseTravelDate(travel.startDate);
                return _EndpointCard(
                  label: travel.originLabel,
                  date: start,
                  isOrigin: true,
                );
              }

              if (isDestination) {
                final end = parseTravelDate(travel.endDate);
                return _EndpointCard(
                  label: travel.destinationLabel,
                  date: end,
                  isOrigin: false,
                );
              }

              final stop = stops[index - 1];
              final status = _getStopStatus(stop);
              final isFirst = index == 1;
              final isLast = index == stops.length;
              return _StopCard(
                key: ValueKey(stop.id),
                stop: stop,
                status: status,
                isFirst: isFirst,
                isLast: isLast,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TimelineConnector extends StatelessWidget {
  const _TimelineConnector();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 24,
          height: 20,
          child: Center(
            child: SizedBox(
              width: 2,
              height: 20,
              child: ColoredBox(color: Color(0xFFD6D6D6)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}

class _EndpointCard extends StatelessWidget {
  const _EndpointCard({
    required this.label,
    required this.date,
    required this.isOrigin,
  });

  final String label;
  final DateTime date;
  final bool isOrigin;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final isPast = dateOnly.isBefore(todayOnly);

    final dotColor = isOrigin
        ? (isPast ? Colors.green : colors.secondary)
        : (isPast ? Colors.green : Colors.redAccent);
    final dotIcon = isOrigin
        ? HugeIcons.strokeRoundedLocation05
        : Icons.flag_outlined;
    final dateLabel = _formatStopShort(date);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: dotColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(dotIcon, size: 12, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isPast
                    ? Colors.green.withValues(alpha: 0.06)
                    : isOrigin
                    ? colors.secondary.withValues(alpha: 0.06)
                    : Colors.redAccent.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isPast
                      ? Colors.green.withValues(alpha: 0.35)
                      : isOrigin
                      ? colors.secondary.withValues(alpha: 0.35)
                      : Colors.redAccent.withValues(alpha: 0.35),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          beforeComma(label),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isPast
                                ? Colors.green
                                : (isOrigin
                                      ? colors.secondary
                                      : Colors.redAccent),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: dotColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          dateLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: dotColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isOrigin ? 'Starting point' : 'Final point',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StopCard extends StatefulWidget {
  const _StopCard({
    super.key,
    required this.stop,
    required this.status,
    required this.isFirst,
    required this.isLast,
  });

  final Stop stop;
  final StopStatus status;
  final bool isFirst;
  final bool isLast;

  @override
  State<_StopCard> createState() => _StopCardState();
}

class _StopCardState extends State<_StopCard> {
  final _repo = ExperienceRepositoryImpl();
  bool _hasReview = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkHasReview();
  }

  @override
  void didUpdateWidget(covariant _StopCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stop.id != widget.stop.id) {
      _loading = true;
      _hasReview = false;
      _checkHasReview();
    }
  }

  Future<void> _checkHasReview() async {
    try {
      final id = widget.stop.id;

      if (id == null) {
        if (!mounted) return;
        setState(() {
          _hasReview = false;
          _loading = false;
        });
        return;
      }
      final list = await _repo.getExperiencesByStopId(id);
      if (!mounted) return;
      setState(() {
        _hasReview = list.isNotEmpty;
        _loading = false;
      });
    } catch (e, s) {
      debugPrint('Erro ao buscar experiências: $e');
      debugPrint('Stack trace: $s');
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final statusColor = _getStatusColor(context, widget.status);
    final statusIcon = _getStatusIcon(widget.status);
    final dateLabel = _formatStopShort(widget.stop.startDate!);
    final activities = (widget.stop.description.trim().isNotEmpty)
        ? widget.stop.description.trim()
        : widget.stop.label;

    final btnBorderColor = _hasReview
        ? Colors.green.withValues(alpha: 0.35)
        : Colors.grey.shade300;
    final btnBgColor = _hasReview
        ? Colors.green.withValues(alpha: 0.06)
        : Colors.grey.shade50;
    final btnIconColor = _loading
        ? const Color(0xFFB0B0B0)
        : (_hasReview ? Colors.green : const Color(0xFFB0B0B0));
    final btnTextColor = _loading
        ? const Color(0xFF757575)
        : (_hasReview ? Colors.green.shade700 : const Color(0xFF757575));

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ponto da linha do tempo
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(statusIcon, size: 12, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.status == StopStatus.current
                    ? colors.secondary.withValues(alpha: 0.35)
                    : widget.status == StopStatus.past
                    ? Colors.green.withValues(alpha: 0.06)
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: widget.status == StopStatus.current
                      ? colors.secondary.withValues(alpha: 0.35)
                      : widget.status == StopStatus.past
                      ? Colors.green.withValues(alpha: 0.35)
                      : Colors.transparent,
                  width: widget.status == StopStatus.upcoming ? 0 : 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          beforeComma(widget.stop.label),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: widget.status == StopStatus.current
                                ? colors.secondary
                                : widget.status == StopStatus.past
                                ? Colors.green
                                : Colors.grey[800],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          dateLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (activities.isNotEmpty)
                    Text(
                      activities,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 4),

          if (widget.status == StopStatus.current ||
              widget.status == StopStatus.past)
            SizedBox(
              width: 70,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: btnBorderColor, width: 2),
                  borderRadius: BorderRadius.circular(10),
                  color: btnBgColor,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: _hasReview
                        ? null
                        : () async {
                            final saved = await showExperienceStopBottomSheet(
                              context,
                              widget.stop.id!,
                            );
                            if (saved == true) {
                              await _checkHasReview();
                            }
                          },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _hasReview
                              ? HugeIcons.strokeRoundedTick02
                              : HugeIcons.strokeRoundedTicketStar,
                          size: 24,
                          color: btnIconColor,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'Avaliar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: btnTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BottomButtons extends StatelessWidget {
  const _BottomButtons({
    required this.travel,
    required this.stops,
    required this.participants,
    required this.experiences,
    required this.onUploadExperience,
  });

  final Travel travel;
  final List<Participant> participants;
  final List<Stop> stops;
  final List<Experience> experiences;
  final Future<void> Function() onUploadExperience;

  @override
  Widget build(BuildContext context) {
    final isTravelCompleted =
        getTravelStatus(
          startDate: parseTravelDate(travel.startDate),
          endDate: parseTravelDate(travel.endDate),
        ) ==
        TravelStatus.completed;
    final allStopsReviewed = experiences.length >= stops.length;
    final canGeneratePdf = isTravelCompleted && allStopsReviewed;

    return InterviewFab(
      nameButton: 'Gerar PDF do Roteiro',
      onPressed: canGeneratePdf
          ? () {
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) {
                  return PopScope(
                    canPop: false,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Gerando o PDF.',
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );

              () async {
                try {
                  await onUploadExperience();
                  final bytes = await generateTripCoverPdf(
                    travel: travel,
                    participants: participants,
                    stops: stops,
                    experiences: experiences,
                    mapsApiKey: dotenv.env['MAPS_API_KEY'] ?? '',
                  );

                  if (context.mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                  await Printing.layoutPdf(onLayout: (_) async => bytes);
                } catch (e) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              }();
            }
          : null,
    );
  }
}

/// The status of a stop in the travel timeline.
enum StopStatus {
  /// The stop has already passed.
  past,

  /// The stop is currently happening.
  current,

  /// The stop is yet to happen.
  upcoming,
}

/// Date format pattern for travel dates.
DateTime parseTravelDate(String stringDate) {
  final parsedDate = tryParseTravelDate(stringDate);
  if (parsedDate == null) {
    throw FormatException(
      'Invalid date: "$stringDate" (expected format $travelDatePattern)',
    );
  }
  return parsedDate;
}

DateTime _asDateOnly(DateTime date) =>
    DateTime(date.year, date.month, date.day);

StopStatus _getStopStatus(Stop stop) {
  final stopDateOnly = _asDateOnly(stop.startDate!);
  final todayDateOnly = _asDateOnly(DateTime.now());
  if (stopDateOnly.isBefore(todayDateOnly)) return StopStatus.past;
  if (stopDateOnly.isAtSameMomentAs(todayDateOnly)) return StopStatus.current;
  return StopStatus.upcoming;
}

String _formatStopShort(DateTime date) =>
    DateFormat('dd MMM', 'pt_BR').format(date.toLocal());

Color _getStatusColor(BuildContext context, StopStatus status) {
  final colors = Theme.of(context).extension<AppColors>()!;
  switch (status) {
    case StopStatus.current:
      return colors.secondary;
    case StopStatus.past:
      return Colors.green;
    case StopStatus.upcoming:
      return Colors.grey.shade500;
  }
}

IconData _getStatusIcon(StopStatus status) {
  switch (status) {
    case StopStatus.current:
      return HugeIcons.strokeRoundedLocation05;
    case StopStatus.past:
      return HugeIcons.strokeRoundedTick02;
    case StopStatus.upcoming:
      return HugeIcons.strokeRoundedCalendar03;
  }
}

class _ParticipantsList extends StatelessWidget {
  const _ParticipantsList({required this.participants});

  final List<Participant> participants;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return SizedBox(
      height: 80,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: participants.length,
        itemBuilder: (context, index) {
          final participant = participants[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 55,
                  height: 55,
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
                            frameBuilder: (context, child, frame, wasSync) {
                              if (wasSync) return child;
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: frame == null
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : child,
                              );
                            },
                          ),
                  ),
                ),
                SizedBox(
                  width: 65,
                  child: Text(
                    participant.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
