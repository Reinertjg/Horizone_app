import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide DatePickerMode;
import 'package:provider/provider.dart';

import '../../../domain/usecases/get_place_suggestions.dart';
import '../../state/interview_provider.dart';
import '../../state/travelstops_provider.dart';
import '../../theme_color/app_colors.dart';
import '../google_places_autocomplete_textfield.dart';
import '../interview_widgets/cupertino_textfield.dart';

class TravelRouteCard extends StatefulWidget {
  const TravelRouteCard({super.key, required this.labelStart, required this.labelEnd});

  final String labelStart;
  final String labelEnd;

  @override
  State<TravelRouteCard> createState() => _TravelRouteCardState();
}

class _TravelRouteCardState extends State<TravelRouteCard> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final interviewProvider = Provider.of<InterviewProvider>(context);
    final travelStopsProvider = context.watch<TravelStopsProvider>();
    final service = PlacesService(
      apiKey: 'AIzaSyAgT9pV0ONamMF8ByF008OT7lf4-1oAFd0',
    );
    return Card(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.labelStart,
                    style: TextStyle(color: colors.quaternary),
                  ),
                  Icon(
                    CupertinoIcons.delete_left,
                    color: colors.secondary,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GooglePlacesAutocomplete(
                service: service,
                hintText: 'Pesquisar endereço...',
                icon: CupertinoIcons.placemark,
                onSelected: (placeId, description) async {
                  print('Selecionado: $description ($placeId)');
                  await travelStopsProvider.resolveAndSetPlace(
                    index: 0,
                    placeId: placeId,
                    label: description,
                  );
                },
              ),
              const SizedBox(height: 8),

              Text(
                widget.labelEnd,
                style: TextStyle(color: colors.quaternary),
              ),
              const SizedBox(height: 12),

              GooglePlacesAutocomplete(
                service: service,
                hintText: 'Pesquisar endereço...',
                icon: CupertinoIcons.placemark,
                onSelected: (placeId, description) async {
                  print('Selecionado: $description ($placeId)');
                  await travelStopsProvider.resolveAndSetPlace(
                    index: travelStopsProvider.length - 1,
                    placeId: placeId,
                    label: description,
                  );
                },
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    /// First date picker field for selecting the start date.
                    child: CupertinoDatePickerField(
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
                  const SizedBox(width: 8),
                  Expanded(
                    /// Second date picker field for selecting the end date.
                    child: CupertinoDatePickerField(
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
            ],
          ),
        ),
      ),
    );
  }
}
