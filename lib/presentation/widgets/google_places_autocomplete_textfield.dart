import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
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
  void initState() {
    super.initState();
    widget.service.resetSession();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return TypeAheadField<Map<String, String>>(
      suggestionsCallback: widget.service.fetchSuggestions,
      loadingBuilder: _circularLoadingBuilder,
      emptyBuilder: (context) => _textEmptyBuilder(context, _controller),
      builder: (context, controller, focusNode) {
        _controller = controller;
        return TextField(
          controller: controller,
          focusNode: focusNode,
          style: TextStyle(
            color: colors.quaternary,
            fontSize: 16,
          ),
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
          tileColor: colors.quinary.withValues(alpha: 0.9),
          leading: Icon(Icons.place_outlined, color: colors.quaternary,
          ),
          title: Text(
            suggestion['description']!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.raleway(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colors.quaternary,
            ),
          ),
        );
      },
      onSelected: (suggestion) {
        _controller?.text = suggestion['description']!; // Update the text

        widget.onSelected(suggestion['placeId']!, suggestion['description']!);
        widget.service.resetSession();

        FocusScope.of(context).unfocus();
      },
    );
  }
}

Widget _circularLoadingBuilder(BuildContext context) {
  final colors = Theme.of(context).extension<AppColors>()!;
  return Container(
    decoration: BoxDecoration(
      color: colors.quinary,
      borderRadius: BorderRadius.circular(16),
    ),
    height: 50,
    child: Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(colors.tertiary),
        strokeWidth: 3.0,
      ),
    ),
  );
}

Widget _textEmptyBuilder(
  BuildContext context,
    TextEditingController? _controller
) {
  final colors = Theme.of(context).extension<AppColors>()!;
  return _controller?.text == ''
      ? SizedBox()
      : Container(
          decoration: BoxDecoration(
            color: colors.quinary,
            borderRadius: BorderRadius.circular(16),
          ),
          height: 50,
          child: Center(
            child: Text(
              'Localização não encontrada!',
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colors.quaternary,
              ),
            ),
          ),
        );
}
