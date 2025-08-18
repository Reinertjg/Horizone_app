import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../domain/usecases/get_place_suggestions.dart';
import '../theme_color/app_colors.dart';

class GooglePlacesAutocomplete extends StatefulWidget {
  final PlacesService service;
  final String hintText;
  final IconData icon;
  final void Function(String placeId, String description) onSelected;

  const GooglePlacesAutocomplete({
    super.key,
    required this.service,
    required this.hintText,
    required this.onSelected,
    required this.icon,
  });

  @override
  State<GooglePlacesAutocomplete> createState() =>
      _GooglePlacesAutocompleteState();
}

class _GooglePlacesAutocompleteState extends State<GooglePlacesAutocomplete> {
  TextEditingController? _controller;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return TypeAheadField<Map<String, String>>(
      suggestionsCallback: widget.service.fetchSuggestions,
      builder: (context, controller, focusNode) {
        _controller = controller;
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            hint: Text(
              widget.hintText,
              style: TextStyle(
                color: colors.secondary.withValues(alpha: 0.3),
                fontSize: 16,
              ),
            ),
            prefixIcon: Icon(widget.icon, color: colors.tertiary, size: 20),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.tertiary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.tertiary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.tertiary),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colors.tertiary),
            ),
            errorStyle: const TextStyle(backgroundColor: Colors.transparent),
          ),
        );
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          leading: const Icon(Icons.place_outlined),
          title: Text(
            suggestion['description']!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
      onSelected: (suggestion) {
        _controller?.text = suggestion['description']!; // Atualiza o campo

        widget.onSelected(suggestion['placeId']!, suggestion['description']!);
        widget.service.resetSession();

        FocusScope.of(context).unfocus();
      },
    );
  }
}
