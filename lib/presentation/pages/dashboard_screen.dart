import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../domain/entities/profile.dart';
import '../../domain/entities/travel.dart';
import '../../generated/l10n.dart';

import '../../repositories/participant_repository_impl.dart';
import '../../repositories/profile_repository_impl.dart';
import '../../repositories/stop_repository_impl.dart';
import '../../repositories/travel_repository_impl.dart';
import '../theme_color/app_colors.dart';
import '../widgets/iconbutton_notifications.dart';
import '../widgets/iconbutton_settings.dart';
import '../widgets/interview_widgets/blinking_dot.dart';

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
    final TravelsSearched = await repositoryTravel.getTravelByStatus(
      'active',
    );
    setState(() {
      travels = TravelsSearched;
    });
  }

  final List<String> travelDestinations = [
    'Rio',
    'Caribe',
    'Dubai',
    'Ilhas Malvinas',
    'Bali',
    'Paris',
  ];

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
              travels.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 65.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedAirplaneModeOff,
                              size: 50,
                              color: Colors.grey,
                            ),
                            Text(
                              'No travels found.',
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
                  : SizedBox(
                      height: 200,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: travels.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => _travelCards(
                          travels: travels.reversed.toList()[index],
                        ),
                      ),
                    ),

              Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                  right: 20.0,
                  left: 20.0,
                  bottom: 8.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Where would you like to visit?',
                    style: GoogleFonts.raleway(
                      color: colors.quaternary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 6,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                          width: 75,
                          height: 75,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Card(
                              elevation: 2,
                              clipBehavior: Clip.antiAlias,
                              shape: CircleBorder(),
                              color: colors.quinary,
                              child: Image.asset(
                                'assets/images/travel_image0${index + 1}.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        Text(
                          travelDestinations[index],
                          style: GoogleFonts.raleway(
                            color: colors.quaternary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

/// Widget representing a travel card.
class _travelCards extends StatelessWidget {
  const _travelCards({required this.travels});

  /// The index of the travel card.
  final Travel travels;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            print('\n----Inserido com sucesso----\n');
            final repositoryParticipant = ParticipantRepositoryImpl();
            final repositoryStop = StopRepositoryImpl();
            final stop = await repositoryStop.getStopsByTravelId(
              travels.id!,
            );
            final participant = await repositoryParticipant.getParticipantsByTravelId(
              travels.id!,
            );
            print('Titile: ${travels.title}');
            print('Start Date: ${travels.startDate}');
            print('End Date: ${travels.endDate}');
            print('Means of Transportation: ${travels.meansOfTransportation}');
            print('Number of Participants: ${travels.numberOfParticipants}');
            print('Experience Type: ${travels.experienceType}');
            print('Origin Place: ${travels.originPlace}');
            print('Origin Label: ${travels.originLabel}');
            print('Destination Place: ${travels.destinationPlace}');
            print('Destination Label: ${travels.destinationLabel}');
            print('Status: ${travels.status}');
            print('-----------------------------');
            print('Participants:');
            for (var item in participant) {
              print('Id: ${item.id}');
              print('Name: ${item.name}');
              print('Email: ${item.email}');
              print('Photo: ${item.photo ?? 'No photo'}');
              print('TravelId: ${item.travelId}');
              print('-----------------------------');
            }
            print('Stops:');
            for (var item in stop) {
              print('Id: ${item.id}');
              print('Order: ${item.order}');
              print('Place: ${item.place.toString()}');
              print('Label: ${item.label}');
              print('Start Date: ${item.startDate}');
              print('End Date: ${item.endDate}');
              print('TravelId: ${item.travelId}');
              print('-----------------------------');
            }
          },
          child: SizedBox(
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
                  'assets/images/travel_image01.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 18,
          left: 15,
          child: Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.white.withValues(alpha: 0.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                BlinkingDot(),
                SizedBox(width: 6),
                Text(
                  "Em andamento",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 15,
          right: 15,
          child: Icon(
            CupertinoIcons.arrow_up_right_square_fill,
            color: colors.quinary,
            size: 25,
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          left: 10,
          child: Container(
            width: 50,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              color: colors.quaternary.withValues(alpha: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    travels.title,
                    style: GoogleFonts.raleway(
                      color: colors.quinary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedLocation06,
                        color: colors.quinary,
                        size: 10,
                      ),
                      SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          travels.destinationLabel,
                          style: GoogleFonts.raleway(
                            color: colors.quinary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // ListView.builder(
                  //   itemCount: 5,
                  //   shrinkWrap: true,
                  //   scrollDirection: Axis.horizontal,
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   itemBuilder: (context, index) {
                  //     return Icon(
                  //       HugeIcons.strokeRoundedStar,
                  //       color: colors.quinary,
                  //       size: 12,
                  //     );
                  //   },
                  // ),
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: colors.tertiary,
                        size: 16,
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.star_rounded,
                        color: colors.tertiary,
                        size: 16,
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.star_rounded,
                        color: colors.tertiary,
                        size: 16,
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.star_rounded,
                        color: colors.tertiary,
                        size: 16,
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.star_outline_rounded,
                        color: colors.tertiary,
                        size: 16,
                      ),
                      SizedBox(width: 2),
                      Text(
                        '4.6',
                        style: GoogleFonts.nunito(
                          color: colors.quinary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
