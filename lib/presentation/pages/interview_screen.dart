import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../state/interview_provider.dart';
import '../theme_color/app_colors.dart';
import '../widgets/interview_widgets/cupertino_textfield.dart';
import '../widgets/interview_widgets/interview_fab.dart';
import '../widgets/interview_widgets/interview_form_card.dart';
import '../widgets/interview_widgets/interview_textfield.dart';
import '../widgets/interview_widgets/interview_textfield_box.dart';
import '../widgets/section_title.dart';

/// Screen where the user fills out general travel information
/// as part of the trip planning flow.
class InterviewScreen extends StatefulWidget {
  /// Creates an [InterviewScreen] widget.
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

/// State class for [InterviewScreen]
/// Responsible for form management and layout.
class _InterviewScreenState extends State<InterviewScreen> {
  /// Global form key used to validate and manage form state.
  final formKey = GlobalKey<FormState>();

  /// Current quantity of participants or related value (if applicable).
  int qtd = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final interviewProvider = Provider.of<InterviewProvider>(context);

    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          S.of(context).planningTravel,
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.secondary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    SectionTitle(
                      title: 'Informações Gerais',
                      icon: CupertinoIcons.info,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                InterviewFormCard(),
                const SizedBox(height: 36),
                Row(
                  children: [
                    SectionTitle(
                      title: 'Rotas',
                      icon: CupertinoIcons.map_pin_ellipse,
                    ),
                  ],
                ),
                const SizedBox(height: 8),


                /// TODO First card for trip route
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: colors.quinary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InterviewTextField(
                            nameButton: 'Local de Origem',
                            hintText: 'Ex: São Paulo, Paris',
                            icon: CupertinoIcons.placemark,
                            controller: interviewProvider.titleController,
                            validator: interviewProvider.validateTitle,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                /// First date picker field for selecting the start date.
                                child: CupertinoDatePickerFieldd(
                                  label: 'Data de Inicío',
                                  fontSize: 12,
                                  icon: Icons.calendar_today_outlined,
                                  mode: DatePickerMode.futureOnly,
                                  controller:
                                      interviewProvider.startDateController,
                                  validator:
                                      interviewProvider.validateStartDate,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                /// Second date picker field for selecting the end date.
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
                          const SizedBox(height: 8),
                          InterviewTextFieldBox(
                            nameButton: 'Descrição das Atividades',
                            hintText:
                                'Descreva as atividades que seram realizadas no local...',
                            icon: CupertinoIcons.ticket,
                            controller: TextEditingController(),
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36,),

                /// TODO Second card for trip route
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: colors.quinary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InterviewTextField(
                            nameButton: 'Local do Destino',
                            hintText: 'Ex: São Paulo, Paris',
                            icon: CupertinoIcons.placemark,
                            controller: interviewProvider.titleController,
                            validator: interviewProvider.validateTitle,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                /// First date picker field for selecting the start date.
                                child: CupertinoDatePickerFieldd(
                                  label: 'Data de Inicío',
                                  fontSize: 12,
                                  icon: Icons.calendar_today_outlined,
                                  mode: DatePickerMode.futureOnly,
                                  controller:
                                  interviewProvider.startDateController,
                                  validator:
                                  interviewProvider.validateStartDate,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                /// Second date picker field for selecting the end date.
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
                          const SizedBox(height: 8),
                          InterviewTextFieldBox(
                            nameButton: 'Descrição das Atividades',
                            hintText:
                            'Descreva as atividades que seram realizadas no local...',
                            icon: CupertinoIcons.ticket,
                            controller: TextEditingController(),
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: InterviewFab(
        nameButton: 'Avançar',
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            if (!context.mounted) return;
            await Navigator.pushNamed(context, '/tripParticipants');

            // final interview = interviewProvider.toEntity();
            //
            // final dao = TripDao();
            // final repository = TripRepositoryImpl(dao);
            // final useCase = InterviewUseCase(repository);
            //
            // await useCase.insert(interview);
          }
        },
      ),
    );
  }
}
