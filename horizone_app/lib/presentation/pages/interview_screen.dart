import 'package:flutter/material.dart';

import '../../database/daos/profile_dao.dart';
import '../widgets/bottom_navigationbar.dart';
import '../widgets/iconbutton_settings.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final profileDao = ProfileDao();
  List<Map<String, dynamic>> profiles = [];

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final perfilBuscado = await profileDao.getProfile();
    setState(() {
      profiles = perfilBuscado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: Text('Planejamento de viagem'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                IconbuttonSettings(),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: bottomNavigationBar(context, 1),
    );
  }
}
