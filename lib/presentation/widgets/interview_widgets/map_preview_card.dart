import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../pages/google_map_screen.dart';
import '../../state/stop_provider.dart';
import '../../state/travel_provider.dart';
import '../../theme_color/app_colors.dart';

/// Card to preview the map of the travel route.
class MapPreviewCard extends StatefulWidget {
  const MapPreviewCard({super.key});

  @override
  State<MapPreviewCard> createState() => _MapPreviewCardState();
}

class _MapPreviewCardState extends State<MapPreviewCard> {
  bool _isLoading = false;

  Future<void> _handleTap() async {
    if (_isLoading) return;

    FocusManager.instance.primaryFocus?.unfocus();

    final colors = Theme.of(context).extension<AppColors>()!;
    final travelProvider = context.read<TravelProvider>();

    final args = context.read<StopProvider>().buildRouteArgs(
      origin: travelProvider.originPlace,
      destination: travelProvider.destinationPlace,
      originLabel: travelProvider.originLabel,
      destinationLabel: travelProvider.destinationLabel,
    );

    if (args == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione origem e destino válidos.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const TravelRoutePage(),
          settings: RouteSettings(arguments: args),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao abrir o mapa: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _handleTap,
          child: AbsorbPointer(
            absorbing: _isLoading,
            child: Stack(
              children: [
                // Card base
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
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
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedGoogleMaps,
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

                // Overlay de loading
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _isLoading
                        ? Container(
                      key: const ValueKey('loading'),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation(colors.secondary),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Carregando mapa…',
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.quaternary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        : const SizedBox.shrink(key: ValueKey('idle')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
