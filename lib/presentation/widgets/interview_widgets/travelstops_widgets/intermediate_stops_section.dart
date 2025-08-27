import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../state/travelstops_provider.dart';
import '../../section_title.dart';
import 'empty_state_message.dart';
import 'travelstop_form_card.dart';

/// Section for displaying intermediate stops.
class IntermediateStopsSection extends StatelessWidget {
  /// Constructs an [IntermediateStopsSection] widget.
  const IntermediateStopsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final stopsProvider = context.watch<TravelStopsProvider>();
    final stops = stopsProvider.stops;
    final stopsCount = stops.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
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
              if (stopsCount == 0)
                const EmptyStateMessage(
                  icon: CupertinoIcons.location_circle,
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

                    return AnimatedContainer(
                      key: ValueKey(travelStop),
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      curve: Curves.easeOutCubic,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(milliseconds: 400 + (index * 100)),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) => Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value.clamp(0.0, 1.0),
                            child: child,
                          ),
                        ),
                        child: StopFormCard(
                          stop: travelStop,
                          label: 'Parada ${index + 1}',
                          order: travelStop.order,
                          index: index,
                        ),
                      ),
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
