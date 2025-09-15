import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../interview_textfield.dart';

/// A form for capturing participant details like name and email.
class ParticipantForm extends StatefulWidget {
  /// Creates a [ParticipantForm] widget.
  const ParticipantForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    this.validateName,
    this.validateEmail,
  });

  /// The global key for the form.
  final GlobalKey<FormState> formKey;

  /// The controller for the name text field.
  final TextEditingController nameController;

  /// The controller for the email text field.
  final TextEditingController emailController;

  /// The validation function for the name text field.
  final String? Function(String?)? validateName;

  /// The validation function for the email text field.
  final String? Function(String?)? validateEmail;

  @override
  State<ParticipantForm> createState() => _ParticipantFormState();
}

class _ParticipantFormState extends State<ParticipantForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          InterviewTextField(
            nameButton: 'Nome',
            hintText: 'Nome do participante',
            icon: HugeIcons.strokeRoundedUser,
            controller: widget.nameController,
            validator: widget.validateName,
          ),
          InterviewTextField(
            nameButton: 'E-mail',
            hintText: 'E-mail do participante',
            icon: HugeIcons.strokeRoundedMail01,
            controller: widget.emailController,
            validator: widget.validateEmail,
            maxLength: 50,
          ),
        ],
      ),
    );
  }
}
