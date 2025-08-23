import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages/google_map_screen.dart';
import '../../../state/interview_provider.dart';
import '../../../state/travelstops_provider.dart';
import '../../../theme_color/app_colors.dart';

/// Card to preview the map of the travel route.
class MapPreviewCard extends StatelessWidget {
  /// Creates a [MapPreviewCard] widget.
  const MapPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final interviewProvider = Provider.of<InterviewProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            final args = context.read<TravelStopsProvider>().buildRouteArgs(
              origin: interviewProvider.originPlace,
              destination: interviewProvider.destinationPlace,
              originLabel: interviewProvider.originLabel,
              destinationLabel: interviewProvider.destinationLabel,
            );
            if (args == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Selecione origem e destino válidos.'),
                ),
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
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
