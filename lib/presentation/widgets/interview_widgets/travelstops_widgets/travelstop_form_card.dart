import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/stop.dart';
import '../../../../domain/usecases/get_place_suggestions.dart';
import '../../../state/stop_provider.dart';
import '../../../theme_color/app_colors.dart';
import '../../google_places_autocomplete_textfield.dart';
import '../cupertino_date_picker.dart';
import 'travelstops_textfield_box.dart';

/// A card widget that represents a form for a single travel stop.
class StopFormCard extends StatelessWidget {
  /// Creates a custom [StopFormCard].
  const StopFormCard({
    super.key,
    required this.label,
    required this.stop,
    required this.order,
    required this.index,
  });

  /// Header label (e.g., "Origin", "Stop 1", "Destination").
  final String label;

  /// The order of the stop in the itinerary.
  final int order;

  /// The index of the stop in the list of stops.
  final int index;

  /// The [Stop] entity associated with this form card.
  final Stop stop;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final stopsProvider = Provider.of<StopProvider>(context);

    final apiKey = dotenv.env['MAPS_API_KEY'];
    final places = PlacesService(apiKey: apiKey!);

    final minStart = stopsProvider.minStartFor(stop.order);
    final maxStart = stopsProvider.maxStartFor(stop.order);
    final initialStart = stopsProvider.initialStartFor(stop.order);

    final minEnd = stopsProvider.minEndFor(stop.order);
    final maxEnd = stopsProvider.maxEndFor(stop.order);
    final initialEnd = stopsProvider.initialEndFor(stop.order);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: colors.quinary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(color: colors.quaternary, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    final stopsProvider = context.read<StopProvider>();
                    stopsProvider.removeStop(stop);
                  },
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedDelete02,
                    color: colors.secondary,
                    size: 25,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Autocomplete -> updates label + coordinates in provider
            GooglePlacesAutocomplete(
              initialText: stop.label,
              service: places,
              hintText: 'Search address...',
              icon: HugeIcons.strokeRoundedMapsSearch,
              onSelected: (placeId, description) async {
                await context.read<StopProvider>().resolveAndSetPlace(
                  stop: stop,
                  placeId: placeId,
                  label: description,
                );
              },
              validator: stopsProvider.validateStopPlace,
            ),

            const SizedBox(height: 8),

            // Dates
            Row(
              children: [
                Expanded(
                  child: CupertinoDatePickerField(
                    label: 'Start date',
                    fontSize: 12,
                    icon: HugeIcons.strokeRoundedDateTime,
                    controller: TextEditingController(
                      text: stopsProvider.formatDate(stop.startDate),
                    ),
                    validator: stopsProvider.validateStopStartDate,
                    maxDate: maxStart,
                    minDate: minStart,
                    initialDate: initialStart ?? DateTime.now(),
                    onDateChanged: (value) =>
                        stopsProvider.setStopStartDate(stop.order, value),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CupertinoDatePickerField(
                    label: 'End date',
                    fontSize: 12,
                    icon: HugeIcons.strokeRoundedDateTime,
                    controller: TextEditingController(
                      text: stopsProvider.formatDate(stop.endDate),
                    ),
                    validator: stopsProvider.validateStopEndDate,
                    maxDate: maxEnd,
                    minDate: minEnd,
                    initialDate: initialEnd ?? DateTime.now(),
                    onDateChanged: (value) =>
                        stopsProvider.setStopEndDate(stop.order, value),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Notes / Description
            TravelStopsTextFieldBox(
              nameButton: 'Activity description',
              hintText: 'Describe the activities at this location...',
              icon: HugeIcons.strokeRoundedTicketStar,
              controller: TextEditingController(text: stop.description),
              keyboardType: TextInputType.text,
            ),
          ],
        ),
      ),
    );
  }
}
