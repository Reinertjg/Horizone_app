import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../domain/entities/profile.dart';
import '../../domain/entities/travel.dart';
import '../../generated/l10n.dart';

import '../../repositories/profile_repository_impl.dart';
import '../../repositories/travel_repository_impl.dart';
import '../../util/date_utils.dart';
import '../../util/travel_status.dart';
import '../theme_color/app_colors.dart';
import '../widgets/dashboard_widgets/travel_card_widget.dart';
import '../widgets/iconbutton_notifications.dart';
import '../widgets/iconbutton_settings.dart';
import '../widgets/show_dialog_image.dart';

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
  final repositoryProfile = ProfileRepositoryImpl();
  final repositoryTravel = TravelRepositoryImpl();

  /// The list of profiles loaded from the data source.
  List<Profile> profiles = [];

  /// The list of travels loaded from the data source.
  List<Travel> travels = [];

  @override
  void initState() {
    super.initState();
    _uploadProfile();
    _uploadTravels();
  }

  /// Loads all profiles from the repository and updates the UI.
  Future<void> _uploadProfile() async {
    final profileSearched = await repositoryProfile.getAllProfiles();
    setState(() {
      profiles = profileSearched;
    });
  }

  /// Loads all travels from the repository and updates the UI.
  Future<void> _uploadTravels() async {
    final travelsSearched = await repositoryTravel.getAllTravels();
    setState(() {
      travels = travelsSearched;
    });
  }

  TravelStatus _statusOf(Travel t) => getTravelStatus(
    startDate: parseTravelDate(t.startDate),
    endDate:   parseTravelDate(t.endDate),
  );

  List<Travel> _by(TravelStatus s) =>
      travels.where((t) => _statusOf(t) == s).toList().reversed.toList();

  Widget _buildStatusSection(String title, List<Travel> items) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Text(
            title,
            style: GoogleFonts.raleway(
              color: colors.quaternary,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: items.isEmpty
              ? Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(HugeIcons.strokeRoundedAirplaneModeOff, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  S.of(context).noTravelsHere,
                  style: GoogleFonts.raleway(
                    color: colors.quaternary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final travel = items[index];
              return TravelCardsWidget(
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    '/travelDashboard',
                    arguments: travel,
                  );
                },
                travel: travel,
              );
            },
          ),
        ),
      ],
    );
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
                padding: const EdgeInsets.only(
                  top: 12.0,
                  right: 12.0,
                  left: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    profiles.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : _DashboardAppBar(profile: profiles.first),
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
                            S.of(context).yourTravels,
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
              travels.isEmpty
                  ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 65.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(HugeIcons.strokeRoundedAirplaneModeOff, size: 50, color: Colors.grey),
                      Text(
                        S.of(context).noTravelsFound,
                        style: GoogleFonts.raleway(
                          color: colors.quaternary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : Column(
                children: [
                  _buildStatusSection(S.of(context).inProgress, _by(TravelStatus.inProgress)),
                  const SizedBox(height: 8),
                  _buildStatusSection(S.of(context).scheduled, _by(TravelStatus.scheduled)),
                  const SizedBox(height: 8),
                  _buildStatusSection(S.of(context).completed, _by(TravelStatus.completed)),
                ],
              ),
            ],
          ),
        ),
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
          TextSpan(text: S.of(context).exploreAmazing),
          TextSpan(
            text: '\n${S.of(context).destinations}!',
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
                S.of(context).search,
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
          onPressed: () async {},
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

class _DashboardAppBar extends StatelessWidget {
  const _DashboardAppBar({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.92,
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
                  child: GestureDetector(
                    onTap: () => showDialogImage(
                      context,
                      profile.photo!,
                      MainAxisAlignment.center,
                    ),
                    child: ClipOval(
                      child: profile.photo == null
                          ? Image.asset(
                              'assets/images/user_default_photo.png',
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              profile.photo!,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              frameBuilder:
                                  (context, child, frame, wasSyncLoaded) {
                                    if (wasSyncLoaded) return child;
                                    return AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      switchInCurve: Curves.easeOut,
                                      switchOutCurve: Curves.easeIn,
                                      child: frame == null
                                          ? Center(
                                              key: const ValueKey('loader'),
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(colors.tertiary),
                                                strokeWidth: 3.0,
                                              ),
                                            )
                                          : KeyedSubtree(
                                              key: const ValueKey('img'),
                                              child: child,
                                            ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/user_default_photo.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${S.of(context).welcome}, '
                    '${profile.name.isNotEmpty ? profile.name : 'User'}',
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
}
