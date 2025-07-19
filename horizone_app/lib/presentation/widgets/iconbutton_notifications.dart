import 'package:flutter/material.dart';

class IconbuttonNotifications extends StatelessWidget {
  const IconbuttonNotifications({super.key});

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
            Icons.notifications_none,
            color: Theme.of(context).highlightColor,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
