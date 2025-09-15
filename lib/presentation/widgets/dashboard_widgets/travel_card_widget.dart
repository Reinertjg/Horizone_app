import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../domain/entities/travel.dart';
import '../../../util/date_utils.dart';
import '../../../util/travel_status.dart';
import '../../theme_color/app_colors.dart';
import 'status_chip.dart';

/// Widget representing a travel card.
class TravelCardsWidget extends StatelessWidget {
  /// Creates a [TravelCardsWidget] widget.
  const TravelCardsWidget({super.key, required this.travel, this.onTap});

  /// The index of the travel card.
  final Travel travel;

  /// Callback function to be executed when the travel card is tapped.
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
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
                child: _TravelImage(travel: travel),
              ),
            ),
          ),
        ),

        Positioned(
          top: 15,
          right: 15,
          child:
              /// Arrow to travel
              _ArrowTravelButton(),
        ),

        ///
        Positioned(
          top: 18,
          left: 15,
          child:
              /// Status of the travel
              StatusChip(
                status: getTravelStatus(
                  startDate: parseTravelDate(travel.startDate),
                  endDate: parseTravelDate(travel.endDate),
                ),
              ),
        ),

        /// Bottom container with travel info
        /// Title, destination, rating
        _TravelInfo(travel.title, travel.destinationLabel, travel.rating),
      ],
    );
  }
}

/// Widget that displays the travel image.
class _TravelImage extends StatelessWidget {
  const _TravelImage({required this.travel});

  final Travel travel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return travel.image == null
        ? Image.asset(
            'assets/images/travel_default_photo.png',
            fit: BoxFit.cover,
          )
        : Image.file(
            travel.image!,
            fit: BoxFit.cover,
            gaplessPlayback: true,

            /// Animated image loading
            frameBuilder: (context, child, frame, wasSyncLoaded) {
              if (wasSyncLoaded || frame != null) {
                return child;
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(colors.tertiary),
                    strokeWidth: 3.0,
                  ),
                );
              }
            },

            /// Error image loading
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/travel_default_photo.png',
                fit: BoxFit.cover,
              );
            },
          );
  }
}

class _ArrowTravelButton extends StatelessWidget {
  const _ArrowTravelButton();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Stack(
      alignment: Alignment.center,
      children: [
        // This will be the "inner" color of the square
        Icon(
          CupertinoIcons.square_fill,
          color: colors.quaternary.withValues(alpha: 0.7),
          // Color for the inside
          size: 25,
        ),
        // This is the arrow on top
        Icon(
          CupertinoIcons.arrow_up_right,
          color: colors.quinary,
          // This will color the arrow and can be seen as the "border"
          size: 20,
        ),
      ],
    );
  }
}

class _TravelInfo extends StatelessWidget {
  const _TravelInfo(this.title, this.destination, this.rating);

  final String title;
  final String destination;
  final double? rating;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Positioned(
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
              /// Title and destination
              _TravelTitleAndDestination(
                title: title,
                destination: destination,
              ),

              /// Rating stars
              _RatingStars(rating: rating ?? 0.0),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget for displaying the title and destination of a travel.
class _TravelTitleAndDestination extends StatelessWidget {
  /// Creates a [_TravelTitleAndDestination] widget.
  const _TravelTitleAndDestination({
    required this.title,
    required this.destination,
  });

  /// The title of the travel.
  final String title;

  /// The destination of the travel.
  final String destination;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
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
            const SizedBox(width: 2),
            Expanded(
              child: Text(
                destination,
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
      ],
    );
  }
}

class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    // ignore: unnecessary_null_comparison
    return rating == null
        ? Row(
            children: [
              Row(
                children: List.generate(5, (index) {
                  final isFullStar = index < rating.floor();
                  final isHalfStar =
                      index == rating.floor() && rating.remainder(1) >= 0.5;

                  return Icon(
                    isFullStar
                        ? Icons.star_rounded
                        : (isHalfStar
                              ? Icons.star_half_rounded
                              : Icons.star_outline_rounded),
                    color: colors.tertiary,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(width: 4),
              Text(
                '$rating',
                style: GoogleFonts.nunito(
                  color: colors.quinary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}
