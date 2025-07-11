import 'package:flutter/material.dart';

class ProfileInfoText extends StatelessWidget {
  const ProfileInfoText({
    required this.tellUs,
    required this.whoYouAre,
    required this.andWellTake,
    super.key,
  });

  final String tellUs;
  final String whoYouAre;
  final String andWellTake;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
        children: [
          TextSpan(text: tellUs),
          TextSpan(
            text: whoYouAre,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          TextSpan(
            text: andWellTake,
            style: TextStyle(overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
