import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../state/interview_provider.dart';
import '../theme_color/app_colors.dart';
import '../widgets/bottom_actions.dart';
import '../widgets/interview_widgets/cupertino_textfield.dart';
import '../widgets/interview_widgets/interview_textfield.dart';
import '../widgets/orange_text_box_form.dart';
import '../widgets/section_title.dart';

/// Screen responsible for collecting travel stop information,
/// including location, coordinates, date range, and planned activities.
class TripStopsScreen extends StatefulWidget {
  /// Creates a [TripStopsScreen] widget.
  const TripStopsScreen({super.key});

  @override
  State<TripStopsScreen> createState() => _TripStopsScreenState();
}

/// State class for [TripStopsScreen], manages the layout and form fields
/// for collecting detailed stop information.
class _TripStopsScreenState extends State<TripStopsScreen> {
  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<InterviewProvider>(context);
    final colors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        toolbarHeight: 65,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'PARADAS DA VIAGEM',
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.secondary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            child: Column(
              children: [
                SectionTitle(title: 'Local de Origem', icon: Icons.flag),
                const SizedBox(height: 6),
                Card(
                  color: colors.quinary,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        InterviewTextField(
                          nameButton: 'Nome da cidade',
                          hintText: 'Município',
                          icon: Icons.home_work,
                          controller: TextEditingController(),
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: InterviewTextField(
                                nameButton: 'Latitude',
                                hintText: 'Insira',
                                icon: Icons.gps_fixed,
                                controller: TextEditingController(),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InterviewTextField(
                                nameButton: 'Longitude',
                                hintText: 'Insira',
                                icon: Icons.place_outlined,
                                controller: TextEditingController(),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
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
                                controller:
                                interviewProvider.startDateController,
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
                                controller:
                                interviewProvider.endDateController,
                                validator: interviewProvider.validateEndDate,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        InterviewTextField(
                          nameButton: 'Tempo de Permanência (dias)',
                          hintText: 'Ex: 10',
                          icon: Icons.access_time,
                          controller: TextEditingController(),
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 12),
                        OrangeTextBoxForm(
                          hintText:
                          'Descreva as atividades preparados por Marcelo..',
                          nameButton: 'Atividade e Atrações',
                          icon: Icons.local_activity_outlined,
                          controller: TextEditingController(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: BottomActions(
        onPressed: () {
          Navigator.of(context).pushNamed('/tripStops');
        },
      ),
    );
  }
}
