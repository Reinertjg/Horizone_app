import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/stop.dart';
import '../../domain/entities/travel.dart';
import '../../repositories/stop_repository_impl.dart';
import '../../util/date_utils.dart';
import '../../util/string_utils.dart';
import '../../util/travel_status.dart';
import '../theme_color/app_colors.dart';
import '../widgets/dashboard_widgets/status_chip.dart';
import '../widgets/dashboard_widgets/travel_card_widget.dart' hide TravelStatus;
import '../widgets/iconbutton_settings.dart';
import '../widgets/section_title.dart';

class TravelDashboardScreen extends StatefulWidget {
  const TravelDashboardScreen({super.key, required this.travel});

  final Travel travel;

  @override
  State<TravelDashboardScreen> createState() => _TravelDashboardScreenState();
}

class _TravelDashboardScreenState extends State<TravelDashboardScreen> {
  final repositoryStop = StopRepositoryImpl();
  List<Stop> stops = [];
  String currentLocation = '';
  String? currentLocationDate;



  bool _isTravelOngoing() {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final endDate = parseTravelDate(widget.travel.endDate);
    final endDateOnly = DateTime(endDate.year, endDate.month, endDate.day);
    final startDate = parseTravelDate(widget.travel.startDate);
    final startDateOnly = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );

    final status = getTravelStatus(
      startDate: parseTravelDate(widget.travel.startDate),
      endDate: parseTravelDate(widget.travel.endDate),
    );
    ;

    if (status == TravelStatus.inProgress) {
      return true;
    }

    return false;
  }

  Future<void> _uploadStops() async {
    try {
      final searched = await repositoryStop.getStopsByTravelId(
          widget.travel.id!);
      setState(() {
        stops = searched;
        _determineCurrentLocation();
      });
    } catch (e) {
      return Future.error(e);
    }
  }

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

    // Default to origin location if no other condition is met within the travel period
    currentLocation = widget.travel.originLabel;

    final currentStop = stops.where((stop) {
      final date = stop.startDate!;
      final stopOnly = DateTime(date.year, date.month, date.day);
      return stopOnly.isAtSameMomentAs(todayOnly);
    }).firstOrNull;

    if (currentStop != null) {
      currentLocation = currentStop.label ?? '';
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
    _uploadStops();
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
            if (_isTravelOngoing())
              _CurrentLocationCard(
                currentLocation: currentLocation,
                currentLocationDate: currentLocationDate,
              ),
            _TravelTimeline(travel: widget.travel, stops: stops),
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
    final inputDateFormat = DateFormat('dd/MM/yyyy');
    final startDate = inputDateFormat.tryParse(travel.startDate);
    final endDate = inputDateFormat.tryParse(travel.endDate);
    final duration = (startDate != null && endDate != null)
        ? endDate
        .difference(startDate)
        .inDays + 1
        : 0;
    final dateFormat = DateFormat('dd MMM yyyy', 'pt_BR');
    final formattedStartDate = startDate != null
        ? dateFormat.format(startDate)
        : '';
    final formattedEndDate = endDate != null ? dateFormat.format(endDate) : '';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
            color: Colors.blue.withValues(alpha: 0.3),
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
                  const SizedBox(height: 18),
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
                color: Colors.white.withOpacity(0.9),
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
    super.key,
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
          color: colors.secondary.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.secondary.withOpacity(0.1),
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
              color: colors.secondary.withOpacity(0.1),
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
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                    color: dotColor.withOpacity(0.3),
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
                  ? Colors.green.withOpacity(0.06)
                  : isOrigin
                  ? colors.secondary.withOpacity(0.06)
                  : Colors.redAccent.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isPast
                    ? Colors.green.withOpacity(0.35)
                    : isOrigin
                    ? colors.secondary.withOpacity(0.35)
                    : Colors.redAccent.withOpacity(0.35),
                width: 2,
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
                        color: dotColor.withOpacity(0.1),
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
    );
  }
}

class _StopCard extends StatelessWidget {
  const _StopCard({
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
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final statusColor = _getStatusColor(context, status);
    final statusIcon = _getStatusIcon(status);
    final dateLabel = _formatStopShort(stop.startDate!);
    final activities = (stop.description
        ?.trim()
        .isNotEmpty ?? false)
        ? stop.description!.trim()
        : (stop.label ?? '');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    color: statusColor.withOpacity(0.3),
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
              color: status == StopStatus.current
                  ? colors.secondary.withOpacity(0.06)
                  : status == StopStatus.past
                  ? Colors.green.withOpacity(0.06)
                  : Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: status == StopStatus.current
                    ? colors.secondary.withOpacity(0.35)
                    : status == StopStatus.past
                    ? Colors.green.withOpacity(0.35)
                    : Colors.transparent,
                width: status == StopStatus.upcoming ? 0 : 2,
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
                        beforeComma(stop.label) ?? 'Parada',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: status == StopStatus.current
                              ? colors.secondary
                              : status == StopStatus.past
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
                        color: statusColor.withOpacity(0.1),
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
      ],
    );
  }
}

enum StopStatus { past, current, upcoming }


DateTime _asDateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

StopStatus _getStopStatus(Stop stop) {
  final stopDateOnly = _asDateOnly(stop.startDate!);
  final todayDateOnly = _asDateOnly(DateTime.now());
  if (stopDateOnly.isBefore(todayDateOnly)) return StopStatus.past;
  if (stopDateOnly.isAtSameMomentAs(todayDateOnly)) return StopStatus.current;
  return StopStatus.upcoming;
}

String _formatStopShort(DateTime d) =>
    DateFormat('dd MMM', 'pt_BR').format(d.toLocal());

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
