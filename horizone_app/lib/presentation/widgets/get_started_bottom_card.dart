import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';

class GetStartedBottomCard extends StatelessWidget {
  const GetStartedBottomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.height * 0.6,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  S.of(context).readyExplore,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/profileSetup');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 52, vertical: 12),
                    ),
                    child: Text(
                      S.of(context).startJourney,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).highlightColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.airplanemode_on_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 26,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
