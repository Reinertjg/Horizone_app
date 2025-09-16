import 'package:flutter/cupertino.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import '../../../state/stop_provider.dart';
import '../../section_title.dart';
import 'empty_state_message.dart';
import 'travelstop_form_card.dart';

/// Section for displaying intermediate stops.
class IntermediateStopsSection extends StatelessWidget {
  /// Constructs an [IntermediateStopsSection] widget.
  const IntermediateStopsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final stopsProvider = context.watch<StopProvider>();
    final stops = stopsProvider.stops;
    final stopsCount = stops.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          children: [
            SectionTitle(
              title: 'Paradas Intermediárias',
              icon: HugeIcons.strokeRoundedMapPinpoint01,
            ),
          ],
        ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Column(
            children: [
              if (stopsCount == 0)
                const EmptyStateMessage(
                  icon: HugeIcons.strokeRoundedMapPinpoint02,
                  title: 'Nenhuma parada intermediária',
                  subtitle: 'Adicione paradas para personalizar sua rota',
                ),
              if (stopsCount > 0)
                ListView.separated(
                  itemCount: stopsCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final travelStop = stops[index];

                    return StopFormCard(
                      key: ValueKey(travelStop),
                      stop: travelStop,
                      label: 'Parada ${index + 1}',
                      order: travelStop.order,
                      index: index,
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}
