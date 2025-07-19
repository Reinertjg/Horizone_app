
import 'package:flutter/material.dart';
import 'package:horizone_app/presentation/widgets/settings_widgets/settingsbottom_sheetcontent.dart';

class IconbuttonSettings extends StatelessWidget {
  const IconbuttonSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      shape: CircleBorder(),
      child: SizedBox(
        height: 35,
        width: 35,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.settings,
            color: Theme.of(context).highlightColor,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context, // Contexto do IconbuttonSettings
              builder: (BuildContext innerContext) {
                return SettingsBottomSheetContent(); // Retorna a instância do seu widget
              },
              // Outras propriedades como isScrollControlled, shape, etc.
            );
          },
        ),
      ),
    );
  }
}
