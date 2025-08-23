import 'package:flutter/material.dart';

import '../interview_textfield.dart';

class ParticipantForm extends StatefulWidget {
  const ParticipantForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    this.validateName,
    this.validateEmail,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final String? Function(String?)? validateName;
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
            icon: Icons.person_outline_rounded,
            controller: widget.nameController,
            validator: widget.validateName,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 8),
          InterviewTextField(
            nameButton: 'E-mail',
            hintText: 'E-mail do participante',
            icon: Icons.email_outlined,
            controller: widget.emailController,
            validator: widget.validateEmail,
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
