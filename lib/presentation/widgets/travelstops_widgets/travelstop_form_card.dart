// lib/presentation/widgets/travelstops_widgets/stop_form_card.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import '../../../domain/usecases/get_place_suggestions.dart';
import '../../state/travelstops_provider.dart';
import '../../theme_color/app_colors.dart';
import '../google_places_autocomplete_textfield.dart';
import '../interview_widgets/cupertino_textfield.dart';
import 'travelstops_textfield_box.dart';

class StopFormCard extends StatelessWidget {
  const StopFormCard({
    super.key,
    required this.index,
    required this.label,
  });

  /// Stop index in the provider list.
  final int index;

  /// Header label (e.g., "Origin", "Stop 1", "Destination").
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final stops = context.watch<TravelStopsProvider>();
    final apiKey = dotenv.env['MAPS_API_KEY'];


    final places = PlacesService(
      apiKey: apiKey!,
    );

    final stop = stops.stops[index];

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
                Text(label, style: TextStyle(color: colors.quaternary)),
                if (index > 0 && index < stops.length - 1)
                  GestureDetector(
                    onTap: () => stops.removeStop(index),
                    child: Icon(CupertinoIcons.delete, color: colors.secondary, size: 20),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Autocomplete -> updates label + coordinates in provider
            GooglePlacesAutocomplete(
              service: places,
              hintText: 'Search address...',
              icon: CupertinoIcons.placemark,
              onSelected: (placeId, description) async {
                await context.read<TravelStopsProvider>().resolveAndSetPlace(
                  index: index,
                  placeId: placeId,
                  label: description,
                );
              },
            ),

            const SizedBox(height: 8),

            // Dates
            Row(
              children: [
                Expanded(
                  child: CupertinoDatePickerField(
                    label: 'Start date',
                    fontSize: 12,
                    icon: Icons.calendar_today_outlined,
                    mode: DatePickerMode.futureOnly,
                    controller: TextEditingController(text: stop.startDate),
                    validator: (_) => null, // put your validator if needed
                    ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CupertinoDatePickerField(
                    label: 'End date',
                    fontSize: 12,
                    icon: Icons.event,
                    mode: DatePickerMode.futureOnly,
                    controller: TextEditingController(text: stop.endDate),
                    validator: (_) => null,
                    ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Notes / Description
            TravelStopsTextFieldBox(
              nameButton: 'Activity description',
              hintText: 'Describe the activities at this location...',
              icon: CupertinoIcons.ticket,
              controller: TextEditingController(text: stop.description),
              keyboardType: TextInputType.text,
            ),
          ],
        ),
      ),
    );
  }
}
