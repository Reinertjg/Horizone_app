import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 1,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/landscape_misurina.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Color(0xffF6F1EB),
                    width: 430,
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ready to explore beyond boundaries?',
                            style: TextStyle(
                              fontSize: 32,
                              color: Color(0xff003566),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xff003566),
                                    padding: EdgeInsets.symmetric(horizontal: 52),
                                  ),
                                  child: Text(
                                      'Your Journey Starts Here',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  ),
                                ),
                              ),
                              Icon(
                                  Icons.airplanemode_on_outlined,
                                  color: Color(0xff003566),
                                size: 26,
                              )
                            ],
                          ),
                        ],
                      ),
                    )

                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
