import 'package:flutter/material.dart';

import '../theme_color/app_colors.dart';

/// A widget that displays bottom action buttons: "Cancel" and "Next".
///
/// Used in Trip form or onboarding steps to allow users to go back
/// or proceed to the next screen.
class BottomActions extends StatelessWidget {
  /// Creates a [BottomActions] widget with the required [onPressed] callback.
  const BottomActions({super.key, required this.onPressed});

  /// Callback executed when the "Next" button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.only(left: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: colors.quinary,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(width: 1.5, color: colors.secondary),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.secondary, Colors.lightBlueAccent],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/tripStops');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Avançar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
