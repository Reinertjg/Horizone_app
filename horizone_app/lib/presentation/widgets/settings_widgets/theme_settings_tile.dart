
import 'package:flutter/material.dart';
import 'package:horizone_app/presentation/widgets/settings_widgets/theme_selection_dialog.dart';
import '../../../generated/l10n.dart';
import '../../state/theme_provider.dart';

class ThemeSettingsTile extends StatelessWidget {
  const ThemeSettingsTile({super.key, required this.themeProvider});

  final ThemeProvider themeProvider;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        S.of(context).theme,
        style: TextStyle(
          color: Theme.of(
            context,
          ).primaryColor,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).primaryColor,
        size: 20,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return ThemeSelectionDialog(themeProvider: themeProvider,);
          },
        );
      },
    );
  }
}
