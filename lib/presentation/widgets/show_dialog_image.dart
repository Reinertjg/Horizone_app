import 'dart:io';

import 'package:flutter/material.dart';
import '../theme_color/app_colors.dart';

/// Shows a dialog with an image from a [File].
void showDialogImage(
  BuildContext context,
  File? image,
  MainAxisAlignment imageAlignment,
) {
  showDialog(
    context: context,
    builder: (context) {
      return ShowDialogImage(image: image, imageAlignment: imageAlignment);
    },
  );
}

/// Shows a dialog with an image from a URL string.
void showDialogStringImage(
  BuildContext context,
  String? image, {
  MainAxisAlignment imageAlignment = MainAxisAlignment.center,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return ShowDialogImage(
        imageString: image,
        imageAlignment: imageAlignment,
      );
    },
  );
}

/// A widget that displays an image in a dialog.
/// The image can be from a [File] or a URL string.
class ShowDialogImage extends StatelessWidget {
  /// Creates a [ShowDialogImage] widget.
  const ShowDialogImage({
    super.key,
    this.image,
    this.imageString,
    required this.imageAlignment,
  });

  /// The image file to display.
  final File? image;

  /// The URL of the image to display.
  final String? imageString;

  /// The alignment of the image within the dialog.
  final MainAxisAlignment imageAlignment;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            mainAxisAlignment: imageAlignment,
            children: [
              Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.secondary,
                ),
                child: ClipOval(child: _buildImage()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (image != null) {
      return Image.file(image!, fit: BoxFit.cover);
    } else if (imageString != null && imageString!.isNotEmpty) {
      return Image.network(imageString!, fit: BoxFit.cover);
    } else {
      return Image.asset(
        'assets/images/user_default_photo.png',
        fit: BoxFit.cover,
      );
    }
  }
}
