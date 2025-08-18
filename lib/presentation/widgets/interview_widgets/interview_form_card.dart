import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:provider/provider.dart';

import '../../state/interview_provider.dart';
import '../../theme_color/app_colors.dart';
import 'build_dropdownform.dart';
import 'cupertino_textfield.dart';
import 'interview_textfield.dart';
import '../participant_widgets/participant_list_preview.dart';

/// A form card widget that collects general information about a trip,
/// including title, start and end dates, transportation, and experience type.
class InterviewFormCard extends StatefulWidget {
  /// Creates a custom [InterviewFormCard].
  const InterviewFormCard({super.key});

  @override
  State<InterviewFormCard> createState() => _InterviewFormCardState();
}

class _InterviewFormCardState extends State<InterviewFormCard> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final interviewProvider = Provider.of<InterviewProvider>(context);
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
                nameButton: 'Titulo da viagem',
                hintText: 'Ex: Viagem da Família Silva 2024',
                icon: Icons.title,
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
                      label: 'Data de Inicío',
                      fontSize: 12,
                      icon: Icons.calendar_today_outlined,
                      mode: DatePickerMode.futureOnly,
                      controller: interviewProvider.startDateController,
                      validator: interviewProvider.validateStartDate,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    /// Second date picker field for selecting the end date.
                    child: CupertinoDatePickerField(
                      label: 'Data de Término',
                      fontSize: 12,
                      icon: Icons.event,
                      mode: DatePickerMode.futureOnly,
                      controller: interviewProvider.endDateController,
                      validator: interviewProvider.validateEndDate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              /// Dropdown form for selecting the means of transportation.
              BuildDropdownform(
                label: 'Meio de Transporte',
                items: ['Carro', 'Avião', 'Ônibus', 'Trem'],
                icon: Icons.directions_car,
                validator: interviewProvider.validateMeansOfTransportation,
                onChanged: (value) =>
                    interviewProvider.meansOfTransportation = value,
              ),
              const SizedBox(height: 12),

              /// Add participant button and participant list preview.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Participantes',
                    style: TextStyle(color: colors.quaternary),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      CupertinoIcons.person_2,
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
                label: 'Tipo e Experiencias',
                items: [
                  'Imersão Cultural',
                  'Explorar Culinárias',
                  'Visitar Locais Históricos',
                  'Visitar Estabelecimentos',
                ],
                icon: Icons.directions_car,
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
