import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../api/place_details_api.dart';
import '../../generated/l10n.dart';
import '../state/interview_provider.dart';
import '../state/travelstops_provider.dart';
import '../theme_color/app_colors.dart';
import '../widgets/interview_widgets/interview_fab.dart';
import '../widgets/interview_widgets/interview_form_card.dart';
import '../widgets/interview_widgets/travel_route_card.dart';
import '../widgets/section_title.dart';
import '../widgets/travelstops_widgets/travelstop_form_card.dart';
import 'google_map_screen.dart';

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
  final apiKey = dotenv.env['MAPS_API_KEY'];

  /// Current quantity of participants or related value (if applicable).
  int qtd = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final interviewProvider = Provider.of<InterviewProvider>(context);
    // no topo do build:
    final stopsProvider = context.watch<TravelStopsProvider>();

    // quantidade de paradas intermediárias = total - origem - destino
    final middleCount = (stopsProvider.length - 2).clamp(0, 1 << 20);
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
                const SizedBox(height: 12),
                InterviewFormCard(),
                const SizedBox(height: 36),
                Row(
                  children: [
                    SectionTitle(
                      title: 'Rota',
                      icon: CupertinoIcons.map_pin_ellipse,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                TravelRouteCard(
                  labelStart: 'Local Origem',
                  labelEnd: 'Local Destino',
                ),
                const SizedBox(height: 16),

                SectionTitle(title: 'Mapa do Roteiro', icon: Icons.map),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () async {
                    final args = context.read<TravelStopsProvider>().buildRouteArgs();

                    if (args == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Selecione origem e destino válidos.')),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TravelRoutePage(),
                        settings: RouteSettings(arguments: args),
                      ),
                    );
                  },

                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colors.secondary.withValues(alpha: 0.2),
                          colors.secondary
                              .withRed(102)
                              .withGreen(178)
                              .withBlue(255)
                              .withValues(alpha: 0.2),
                        ],
                      ),
                      border: Border.all(color: colors.secondary),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colors.quinary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.map_outlined,
                              size: 40,
                              color: colors.secondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Mapa do Roteiro',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colors.quaternary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Visualização da rota e pontos de parada',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    color: colors.quaternary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colors.quaternary.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    SectionTitle(
                      title: 'Paradas Intermediárias',
                      icon: CupertinoIcons.location_circle,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Column(
                    children: [
                      if (middleCount == 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 16,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                CupertinoIcons.location_circle,
                                size: 48,
                                color: colors.secondary.withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Nenhuma parada intermediária',
                                style: TextStyle(
                                  color: colors.secondary.withValues(
                                    alpha: 0.7,
                                  ),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Adicione paradas para personalizar sua rota',
                                style: TextStyle(
                                  color: colors.secondary.withValues(
                                    alpha: 0.5,
                                  ),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                      if (middleCount > 0)
                        ListView.separated(
                          itemCount: middleCount,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            // mapear índice visual (0..middleCount-1) -> índice real na lista (1..length-2)
                            final realIndex = index + 1;

                            return AnimatedContainer(
                              duration: Duration(
                                milliseconds: 300 + (index * 50),
                              ),
                              curve: Curves.easeOutCubic,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0.0, end: 1.0),
                                duration: Duration(
                                  milliseconds: 400 + (index * 100),
                                ),
                                curve: Curves.easeOutBack,
                                builder: (context, value, child) {
                                  return Transform.scale(
                                    scale: value,
                                    child: Opacity(
                                      opacity: value,
                                      child: StopFormCard(
                                        label: 'Parada ${index + 1}',
                                        index:
                                            realIndex, // <- importante: índice real no provider
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Botão "Adicionar Parada" -> usa o provider (insere antes do destino)
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors.secondary.withValues(alpha: 0.6),
                        colors.secondary
                            .withRed(102)
                            .withGreen(178)
                            .withBlue(255)
                            .withValues(alpha: 0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.secondary),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<TravelStopsProvider>().addStop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          CupertinoIcons.add_circled,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Adicionar Parada',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
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

/// Utility class to handle string parsing operations
class StringUtils {
  /// Returns the substring before the first comma.
  /// If no comma is found, returns the entire string.
  static String beforeComma(String text) {
    final index = text.indexOf(',');
    if (index == -1) return text;
    return text.substring(0, index);
  }
}
