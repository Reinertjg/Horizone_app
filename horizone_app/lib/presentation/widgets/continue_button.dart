import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    required this.title,
    required this.pathRoute,
    super.key,
  });

  final String title;
  final String pathRoute;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, pathRoute);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 12),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).highlightColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
