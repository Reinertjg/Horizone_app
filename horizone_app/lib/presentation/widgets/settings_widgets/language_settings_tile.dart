
import 'package:flutter/material.dart';
import 'package:horizone_app/presentation/widgets/settings_widgets/language_selection_dialog.dart';

import '../../../generated/l10n.dart';
import '../../state/locale_provider.dart';

class LanguageSettingsTile extends StatelessWidget {
  const LanguageSettingsTile({super.key, required this.localeProvider});

  final LocaleProvider localeProvider;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        S.of(context).language,
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
            return LanguageSelectionDialog(localeProvider: localeProvider);
          },
        );
      },
    );
  }
}
