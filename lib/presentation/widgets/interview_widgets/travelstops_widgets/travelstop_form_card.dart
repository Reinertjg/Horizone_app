import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/travelstop.dart';
import '../../../../domain/usecases/get_place_suggestions.dart';
import '../../../state/travelstops_provider.dart';
import '../../../state/trip_dates_provider.dart';
import '../../../theme_color/app_colors.dart';
import '../../google_places_autocomplete_textfield.dart';
import '../test_cupertino_date_picker.dart';
import 'travelstops_textfield_box.dart';

class StopFormCard extends StatelessWidget {
  const StopFormCard({
    super.key,
    required this.label,
    required this.stop,
    required this.order,
    required this.index,
  });

  /// Header label (e.g., "Origin", "Stop 1", "Destination").
  final String label;
  final int order;
  final int index;
  final TravelStop stop;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final stopsProvider = Provider.of<TravelStopsProvider>(context);
    final dateProvider = Provider.of<TripDatesProvider>(context);

    final apiKey = dotenv.env['MAPS_API_KEY'];
    final places = PlacesService(apiKey: apiKey!);

    return GestureDetector(
      key: ValueKey(stop),
      onTap: () {
        print('Ordem: $order');
        print('Stop: ${stop.order}');
        print('Index: $index');
        print('StarDate: ${dateProvider.startDate}');
        print('EndDate: ${dateProvider.endDate}');
      },
      child: Card(
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
                  GestureDetector(
                    onTap: () {
                      final stopsProvider = context.read<TravelStopsProvider>();
                      stopsProvider.removeStop(stop);
                    },
                    child: Icon(
                      HugeIcons.strokeRoundedDelete02,
                      color: colors.secondary,
                      size: 20,
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
                icon: CupertinoIcons.placemark,
                onSelected: (placeId, description) async {
                  await context.read<TravelStopsProvider>().resolveAndSetPlace(
                    stop: stop,
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
                      controller: TextEditingController(
                        text: stop.startDate.toString(),
                      ),
                      validator: (_) => null,
                      maxDate: stopsProvider.maxDateForStop(index),
                      minDate: stopsProvider.minDateForStop(index),
                      initialDate: stopsProvider.initialDateForStop(index),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CupertinoDatePickerField(
                      label: 'End date',
                      fontSize: 12,
                      icon: Icons.event,
                      controller: TextEditingController(
                        text: stop.endDate.toString(),
                      ),
                      validator: (_) => null,
                      maxDate: stopsProvider.maxDateForStop(index),
                      minDate: stopsProvider.minDateForStop(index),
                      initialDate: stopsProvider.initialDateForStop(index),
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
      ),
    );
  }
}
