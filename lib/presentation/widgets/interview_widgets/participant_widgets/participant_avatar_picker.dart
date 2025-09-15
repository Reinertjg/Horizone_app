import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme_color/app_colors.dart';
import '../../bottom_sheet_widgets/options_image_modal.dart';
import '../../show_dialog_image.dart';

/// Options for picking a photo.
enum OptionPhotoMode {
  /// Pick an image from the camera.
  cameraMode,

  /// Pick an image from the gallery.
  galleryMode,
}

/// A widget that allows the user to pick an avatar for a participant.
class ParticipantAvatarPicker extends StatefulWidget {
  /// Creates a [ParticipantAvatarPicker].
  const ParticipantAvatarPicker({
    super.key,
    required this.image,
    required this.onImagePicked,
  });

  /// The image file to display.
  final File? image;

  /// A callback that is called when an image is picked.
  final void Function(File file) onImagePicked;

  @override
  State<ParticipantAvatarPicker> createState() =>
      _ParticipantAvatarPickerState();
}

class _ParticipantAvatarPickerState extends State<ParticipantAvatarPicker> {
  late File? _image;

  @override
  void initState() {
    super.initState();
    _image = widget.image;
  }

  Future<void> _pickImage(OptionPhotoMode mode) async {
    final picker = ImagePicker();
    final source = mode == OptionPhotoMode.cameraMode
        ? ImageSource.camera
        : ImageSource.gallery;

    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _image = file;
      });
      widget.onImagePicked(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => ImagePickerSheet(
                title: 'Opções',
                onCameraTap: () => _pickImage(OptionPhotoMode.cameraMode),
                onVisualizeTap: () =>
                    showDialogImage(context, _image, MainAxisAlignment.start),
                onGalleryTap: () => _pickImage(OptionPhotoMode.galleryMode),
              ),
            );
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: colors.quinary,
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.secondary.withAlpha(80),
                width: 2,
              ),
            ),
            child: _image == null
                ? Icon(
                    CupertinoIcons.camera_on_rectangle,
                    size: 40,
                    color: colors.secondary,
                  )
                : ClipOval(child: Image.file(_image!, fit: BoxFit.cover)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Adicione uma foto de perfil',
          style: GoogleFonts.raleway(
            fontSize: 14,
            color: colors.quaternary.withAlpha(100),
          ),
        ),
      ],
    );
  }
}
