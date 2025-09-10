import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../domain/usecases/get_place_suggestions.dart';
import '../theme_color/app_colors.dart';

class GooglePlacesAutocomplete extends StatefulWidget {
  final String? initialText;
  final PlacesService service;
  final String hintText;
  final IconData icon;

  /// An optional validator for form validation.
  final String? Function(String?)? validator;

  /// Callback when a suggestion is selected.
  final void Function(String placeId, String description) onSelected;

  /// Creates a [GooglePlacesAutocomplete] widget.
  const GooglePlacesAutocomplete({
    super.key,
    this.initialText,
    required this.service,
    required this.hintText,
    required this.onSelected,
    required this.icon,
    this.validator,
  });

  @override
  State<GooglePlacesAutocomplete> createState() =>
      _GooglePlacesAutocompleteState();
}

class _GooglePlacesAutocompleteState extends State<GooglePlacesAutocomplete> {
  final _controller = TextEditingController();

  String? _selectedPlaceId;
  String? _selectedDescription;

  @override
  void didUpdateWidget(covariant GooglePlacesAutocomplete oldWidget) {
    if (oldWidget.hintText != widget.initialText &&
        widget.initialText?.isNotEmpty == true) {
      _controller.text = widget.initialText ?? '';
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();

    if (_controller.text != widget.initialText &&
        widget.initialText?.isNotEmpty == true) {
      _controller.text = widget.initialText!;
    }

    widget.service.resetSession();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return TypeAheadField<Map<String, String>>(
      suggestionsCallback: widget.service.fetchSuggestions,
      loadingBuilder: _circularLoadingBuilder,
      emptyBuilder: (context) => _textEmptyBuilder(context, _controller),
      controller: _controller,
      builder: (context, controller, focusNode) {
        return TextFormField(
          controller: _controller,
          focusNode: focusNode,
          validator: widget.validator,
          style: TextStyle(color: colors.quaternary, fontSize: 16),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: colors.secondary.withValues(alpha: 0.3),
              fontSize: 16,
            ),
            prefixIcon: HugeIcon(icon: widget.icon, color: colors.tertiary, size: 20),
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
              borderSide: BorderSide(color: Colors.red),
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
          leading: Icon(Icons.place_outlined, color: colors.quaternary),
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
        _controller.text = suggestion['description']!;
        _selectedPlaceId = suggestion['placeId'];
        _selectedDescription = suggestion['description'];

        widget.onSelected(_selectedPlaceId!, _selectedDescription!);
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
      borderRadius: BorderRadius.circular(8),
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
  TextEditingController? controller,
) {
  final colors = Theme.of(context).extension<AppColors>()!;
  return controller?.text == ''
      ? SizedBox()
      : Container(
          decoration: BoxDecoration(
            color: colors.quinary,
            borderRadius: BorderRadius.circular(8),
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
