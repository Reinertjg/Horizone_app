import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile.dart';
import '../../generated/l10n.dart';

import '../theme_color/app_colors.dart';
import '../widgets/iconbutton_notifications.dart';
import '../widgets/iconbutton_settings.dart';

/// The main screen displayed after user login,
/// showing a personalized welcome and main navigation options.
class DashboardScreen extends StatefulWidget {
  /// Creates a [DashboardScreen] widget.
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

/// State class for [DashboardScreen], responsible for UI rendering and loading.
class _DashboardScreenState extends State<DashboardScreen> {
  /// The repository used to fetch profile data.
  final repository = ProfileRepositoryImpl();

  /// The list of profiles loaded from the data source.
  List<Profile> profiles = [];

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  /// Loads all profiles from the repository and updates the UI.
  Future<void> _carregarPerfil() async {
    final perfilBuscado = await repository.getAllProfiles();
    setState(() {
      profiles = perfilBuscado;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAppBar(),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildRichText(),
                          const SizedBox(height: 16),
                          _buildSearchTravel(),
                          const SizedBox(height: 32),
                          Text(
                            'Your Travels',
                            style: GoogleFonts.raleway(
                              color: colors.quaternary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 200,
                      height: 200,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Card(
                          elevation: 2,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: colors.quinary,
                          child: Image.asset(
                            'assets/images/travel_image0${index + 1}.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 380,
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.secondary.withValues(alpha: 0.1),
                      width: 2,
                    ),
                    color: colors.secondary,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/user_default_photo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${S.of(context).welcome}, '
                        '${profiles.isNotEmpty ? profiles[0].name : 'User'}',
                    style: GoogleFonts.nunito(
                      color: colors.quaternary,
                      fontSize: 22,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    IconbuttonSettings(),
                    const SizedBox(width: 6),
                    IconbuttonNotifications(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichText() {
    final colors = Theme.of(context).extension<AppColors>()!;
    return RichText(
      text: TextSpan(
        style: GoogleFonts.nunito(
          color: colors.quaternary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(text: 'Explore Amazing'),
          TextSpan(
            text: '\nDestinations!',
            style: GoogleFonts.nunito(color: colors.tertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTravel() {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: TextEditingController(),
            style: GoogleFonts.raleway(color: colors.secondary, fontSize: 16),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              hint: Text(
                'Search',
                style: TextStyle(
                  color: colors.secondary.withValues(alpha: 0.3),
                  fontSize: 16,
                ),
              ),
              prefixIcon: Icon(
                HugeIcons.strokeRoundedSearch01,
                color: colors.tertiary,
                size: 20,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.tertiary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.tertiary),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () {},
          icon: Icon(
            HugeIcons.strokeRoundedSettings05,
            color: colors.tertiary,
            size: 25,
          ),
        ),
      ],
    );
  }
}
