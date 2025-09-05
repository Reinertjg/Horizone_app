import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../domain/entities/travel.dart';
import '../../../repositories/participant_repository_impl.dart';
import '../../theme_color/app_colors.dart';
import '../interview_widgets/blinking_dot.dart';

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
              print('Photo: ${item.photo}');
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
                  'Em andamento',
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