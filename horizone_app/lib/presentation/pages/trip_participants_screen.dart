import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizone_app/presentation/state/interview_provider.dart';
import 'package:provider/provider.dart';

import '../theme_color/AppColors.dart';
import '../../generated/l10n.dart';
import '../widgets/interview_widgets/interview_textfield.dart';

class TripParticipantsScreen extends StatefulWidget {
  const TripParticipantsScreen({super.key});

  @override
  State<TripParticipantsScreen> createState() => _TripParticipantsScreenState();
}

class _TripParticipantsScreenState extends State<TripParticipantsScreen> {
  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<InterviewProvider>(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        toolbarHeight: 65,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'PARTICIPANTES',
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.secondary,
          ),
        ),
      ),
      body: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: interviewProvider.participants,
                itemBuilder: (_, index) {
                  return _buildParticipantCard(index);
                },
                padding: const EdgeInsets.only(
                  bottom: 70.0,
                  left: 8.0,
                  right: 8.0,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildBottomActions(),
    );
  }

  Widget _buildParticipantCard(int index) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Card(
      color: colors.quinary,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Person ${(index + 1)}',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.secondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
            ),
            const SizedBox(height: 8),
            InterviewTextField(
              nameButton: S.of(context).name,
              hintText: 'Nome completo',
              icon: Icons.person,
              controller: TextEditingController(),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 8),
            InterviewTextField(
              nameButton: 'E-mail',
              hintText: 'exemple@email.com',
              icon: Icons.email,
              controller: TextEditingController(),
              keyboardType: TextInputType.text,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
                onPressed: () {},
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
