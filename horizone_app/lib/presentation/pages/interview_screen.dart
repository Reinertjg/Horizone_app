import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:google_fonts/google_fonts.dart';
import 'package:horizone_app/database/daos/trip_dao.dart';
import 'package:horizone_app/presentation/widgets/interview_widgets/build_dropdownform.dart';
import 'package:horizone_app/presentation/widgets/interview_widgets/interview_textfield.dart';
import 'package:provider/provider.dart';
import '../theme_color/AppColors.dart';
import '../../database/daos/profile_dao.dart';
import '../../generated/l10n.dart';
import '../state/interview_provider.dart';
import '../widgets/profile_widgets/bottom_navigationbar.dart';
import '../widgets/interview_widgets/cupertino_textfield.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final formKey = GlobalKey<FormState>();
  final profileDao = ProfileDao();
  List<Map<String, dynamic>> profiles = [];
  int qtd = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profileGetted = await profileDao.getProfile();
    setState(() {
      profiles = profileGetted;
    });
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
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.secondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: colors.secondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Informações Gerais',
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
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
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                  controller:
                                      interviewProvider.startDateController,
                                  validator:
                                      interviewProvider.validateStartDate,
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
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          BuildDropdownform(
                            label: 'Meio de Transporte',
                            items: ['Carro', 'Avião', 'Ônibus', 'Trem'],
                            icon: Icons.directions_car,
                            validator:
                                interviewProvider.validateMeansOfTransportation,
                            onChanged:
                                interviewProvider.setMeansOfTransportation,
                          ),
                          const SizedBox(height: 12),
                          InterviewTextField(
                            nameButton: 'Quantidade de Participantes',
                            hintText: 'Ex: 3',
                            icon: Icons.people_alt_outlined,
                            controller: interviewProvider
                                .numberOfParticipantsController,
                            validator:
                                interviewProvider.validateNumberOfParticipants,
                            keyboardType: TextInputType.number,
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
                            onChanged: interviewProvider.setExperienceType,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 45,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.secondary, Colors.lightBlueAccent],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: ElevatedButton(
          onPressed: () async {
            final travels = await TripDao().getAllTrips();
            print(travels);

            interviewProvider.setParticipants(
              int.parse(interviewProvider.numberOfParticipantsController.text),
            );

            if (formKey.currentState!.validate()) {
              Navigator.pushNamed(context, '/tripParticipants');

              // final interview = interviewProvider.toEntity();
              //
              // final dao = TripDao();
              // final repository = TripRepositoryImpl(dao);
              // final useCase = InterviewUseCase(repository);
              //
              // await useCase.insert(interview);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            'Avançar',
            style: GoogleFonts.raleway(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(context, 1),
    );
  }
}
