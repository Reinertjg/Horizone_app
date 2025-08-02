import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../state/interview_provider.dart';
import '../../theme_color/app_colors.dart';
import '../orange_text_form.dart';
import '../settings_widgets/settingsbottom_sheetcontent.dart';
import 'build_dropdownform.dart';
import 'cupertino_textfield.dart';
import 'interview_textfield.dart';

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
                  color: const Color(0xFFF7FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
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
              const SizedBox(height: 12),

              InterviewTextField(
                nameButton: 'Quantidade de Participantes',
                hintText: 'Ex: 3',
                icon: Icons.people_alt_outlined,
                controller: interviewProvider.numberOfParticipantsController,
                validator: interviewProvider.validateNumberOfParticipants,
                keyboardType: TextInputType.number,
              ),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: colors.primary,
                    isScrollControlled: true,
                    context: context,
                    builder: (innerContext) {
                      return Container(
                        constraints: BoxConstraints(maxHeight: 650),
                        padding: EdgeInsets.only(
                          top: 22.0,
                          left: 12.0,
                          right: 12.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 30,
                                    color: colors.secondary,
                                  ),
                                ),
                                Text(
                                  'Participantes',
                                  style: GoogleFonts.raleway(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: colors.secondary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.add_circle,
                                    size: 30,
                                    color: colors.secondary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            OrangeTextForm(
                              nameButton: 'Name',
                              icon: Icons.person,
                              controller: TextEditingController(),
                            ),
                            SizedBox(height: 12),
                            OrangeTextForm(
                              nameButton: 'E-mail',
                              icon: Icons.email,
                              controller: TextEditingController(),
                            ),
                            SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                  // ListView.builder(
                  //   reverse: true,
                  //   scrollDirection: Axis.vertical,
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemCount: index,
                  //   itemBuilder: (_, index) {
                  //     return ParticipantCard(index: index);
                  //   },
                  //   padding: const EdgeInsets.only(
                  //     bottom: 70.0,
                  //     left: 8.0,
                  //     right: 8.0,
                  //   ),
                  // ),
                },
                child: Text(
                  'Adicionar Participante',
                  style: TextStyle(color: colors.secondary),
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
