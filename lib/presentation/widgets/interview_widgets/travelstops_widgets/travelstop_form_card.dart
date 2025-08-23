// lib/presentation/widgets/travelstops_widgets/stop_form_card.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../../domain/usecases/get_place_suggestions.dart';
import '../../../state/travelstops_provider.dart';
import '../../../state/trip_dates_provider.dart';
import '../../../theme_color/app_colors.dart';
import '../../google_places_autocomplete_textfield.dart';
import '../test_cupertino_date_picker.dart';
import 'travelstops_textfield_box.dart';

class StopFormCard extends StatelessWidget {
  const StopFormCard({super.key, required this.index, required this.label});

  /// Stop index in the provider list.
  final int index;

  /// Header label (e.g., "Origin", "Stop 1", "Destination").
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final stopsProvider = context.watch<TravelStopsProvider>();
    final dateProvider = Provider.of<TripDatesProvider>(context);
    final apiKey = dotenv.env['MAPS_API_KEY'];

    final places = PlacesService(apiKey: apiKey!);

    final stop = stopsProvider.stops[index];

    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

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
                if (index > 0 && index < stopsProvider.length - 1)
                  GestureDetector(
                    onTap: () => stopsProvider.removeStop(index),
                    child: Icon(
                      CupertinoIcons.delete,
                      color: colors.secondary,
                      size: 20,
                    ),
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
                    icon: HugeIcons.strokeRoundedCalendar01,
                    controller: TextEditingController(text: stop.startDate.toString()),
                    validator: (_) => null,
                    // put your validator if needed
                    // minDate: dateProvider.minDateForStop(index),
                    // maxDate: dateProvider.maxDateForStop(index),
                    // initialDate: dateProvider.initialDateForStop(index, current: stop.startDate),
                    maxDate:
                    dateProvider.endDate?.subtract(Duration(days: 1)) ??
                        DateTime(2100),
                    minDate: today,
                    initialDate: dateProvider.startDate ?? today,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CupertinoDatePickerField(
                    label: 'End date',
                    fontSize: 12,
                    icon: Icons.event,
                    controller: TextEditingController(text: stop.endDate.toString()),
                    validator: (_) => null,
                    // put your validator if needed
                    // minDate: dateProvider.minDateForStop(index),
                    // maxDate: dateProvider.maxDateForStop(index),
                    // initialDate: dateProvider.initialDateForStop(index, current: stop.startDate),
                    maxDate: DateTime(2100),
                    minDate:
                    dateProvider.startDate?.add(Duration(days: 1)) ??
                        today.add(Duration(days: 1)),
                    initialDate:
                    dateProvider.endDate ??
                        (dateProvider.startDate?.add(Duration(days: 2)) ??
                            today.add(Duration(days: 1))),
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
