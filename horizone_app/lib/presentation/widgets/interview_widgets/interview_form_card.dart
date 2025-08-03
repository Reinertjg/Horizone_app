import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../state/interview_provider.dart';
import '../../state/participant_provider.dart';
import '../../theme_color/app_colors.dart';
import 'build_dropdownform.dart';
import 'cupertino_textfield.dart';
import 'interview_textfield.dart';
import 'show_modal_bottom.dart';

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
    final participantProvider = Provider.of<ParticipantProvider>(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: colors.quinary,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                    child: CupertinoDatePickerFieldd(
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
                    child: CupertinoDatePickerFieldd(
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
              Container(
                decoration: BoxDecoration(
                  color: colors.quaternary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.quaternary),
                ),
              ),
              const SizedBox(height: 12),
              BuildDropdownform(
                label: 'Meio de Transporte',
                items: ['Carro', 'Avião', 'Ônibus', 'Trem'],
                icon: Icons.directions_car,
                validator: interviewProvider.validateMeansOfTransportation,
                onChanged: (value) =>
                    interviewProvider.meansOfTransportation = value,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  showAddMemberModal(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Adicionar Participante',
                      style: TextStyle(color: colors.quaternary),
                    ),
                    Icon(
                      Icons.person_add_alt_1_outlined,
                      color: colors.secondary,
                      size: 30,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
                child: participantProvider.participants.isEmpty
                    ? Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.person,
                              color: colors.secondary,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Nenhum participante adicionado',
                              style: GoogleFonts.raleway(
                                color: colors.quaternary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: participantProvider.participants.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final participant =
                              participantProvider.participants[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 55,
                                height: 55,
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
                                child: ClipOval(
                                  child: Image.network(
                                    'https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                participant.name,
                                style: TextStyle(color: colors.quaternary),
                              ),
                            ],
                          );
                        },
                      ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: colors.quaternary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.quaternary),
                ),
              ),
              const SizedBox(height: 12),
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
