import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../state/interview_provider.dart';
import '../../state/travelstops_provider.dart';
import '../../theme_color/app_colors.dart';
import 'build_dropdownform.dart';
import 'interview_textfield.dart';
import 'participant_widgets/participant_list_preview.dart';
import 'cupertino_date_picker.dart';

/// A form card widget that collects general information about a trip,
/// including title, start and end dates, transportation, and experience type.
class InterviewFormCard extends StatefulWidget {
  /// Creates a custom [InterviewFormCard].
  const InterviewFormCard({super.key});

  @override
  State<InterviewFormCard> createState() => _InterviewFormCardState();
}

class _InterviewFormCardState extends State<InterviewFormCard> {
  final today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  void initState() {
    Provider.of<InterviewProvider>(context, listen: false).startDateController.text =
       DateFormat('dd/MM/yyyy').format(today);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final interviewProvider = Provider.of<InterviewProvider>(context);
    final stopsProvider = Provider.of<TravelStopsProvider>(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colors.quinary,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// Text field for entering the title of the trip.
              InterviewTextField(
                nameButton: S.of(context).tripTitle,
                hintText: 'Ex: Viagem da Família Silva 2024',
                icon: HugeIcons.strokeRoundedTextCircle,
                controller: interviewProvider.titleController,
                validator: interviewProvider.validateTitle,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    /// First date picker field for selecting the start date.
                    child: CupertinoDatePickerField(
                      label: S.of(context).startDate,
                      fontSize: 12,
                      icon: HugeIcons.strokeRoundedCalendarCheckIn01,
                      controller: interviewProvider.startDateController,
                      validator: interviewProvider.validateStartDate,
                      maxDate:
                          stopsProvider.tripEnd?.subtract(Duration(days: 1)) ??
                          DateTime(2100),
                      minDate: today,
                      initialDate: stopsProvider.tripStart ?? today,
                      onDateChanged: stopsProvider.setTripStart,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    /// Second date picker field for selecting the end date.
                    child: CupertinoDatePickerField(
                      label: S.of(context).endDate,
                      fontSize: 12,
                      icon: HugeIcons.strokeRoundedCalendarCheckOut01,
                      controller: interviewProvider.endDateController,
                      validator: interviewProvider.validateEndDate,
                      maxDate: DateTime(2100),
                      minDate:
                          stopsProvider.tripStart?.add(Duration(days: 1)) ??
                          today.add(Duration(days: 1)),
                      initialDate:
                          stopsProvider.tripEnd ??
                          (stopsProvider.tripStart?.add(Duration(days: 1)) ??
                              today.add(Duration(days: 1))),
                      onDateChanged: stopsProvider.setTripEnd,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// Dropdown form for selecting the means of transportation.
              BuildDropdownform(
                label: S.of(context).meansOfTransport,
                items: ['Carro', 'Avião', 'Ônibus', 'Trem'],
                icon: HugeIcons.strokeRoundedAirplane01,
                validator: interviewProvider.validateMeansOfTransportation,
                onChanged: (value) =>
                    interviewProvider.meansOfTransportation = value,
              ),
              const SizedBox(height: 12),

              /// Text field for entering the number of participants.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).participants,
                    style: TextStyle(color: colors.quaternary),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      HugeIcons.strokeRoundedUserMultiple02,
                      color: colors.secondary,
                      size: 25,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Participant list preview.
              ParticipantListPreview(),

              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: colors.quaternary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colors.quaternary.withValues(alpha: 0.1),
                  ),
                ),
              ),
              const SizedBox(height: 6),

              /// Dropdown form for selecting the type of experience.
              BuildDropdownform(
                label: S.of(context).typeAndExperience,
                items: [
                  'Imersão Cultural',
                  'Explorar Culinárias',
                  'Visitar Locais Históricos',
                  'Visitar Estabelecimentos',
                ],
                icon: HugeIcons.strokeRoundedLocationFavourite01,
                validator: interviewProvider.validateExperienceType,
                onChanged: (value) => interviewProvider.experienceType = value,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
