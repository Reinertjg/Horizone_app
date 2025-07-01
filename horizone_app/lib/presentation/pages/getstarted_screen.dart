import 'package:flutter/material.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  var selectedLanguage = 'English';

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
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: DropdownButton<String>(
                      value: selectedLanguage,
                      underline: SizedBox(),
                      icon: Icon(Icons.arrow_drop_down, size: 22, color: Colors.white,),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      dropdownColor: Color(0xff003566),
                      items: ['English', 'Português', 'Español'].map((lang) {
                        return DropdownMenuItem(
                          value: lang,
                          child: Text(lang),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value!;
                        });
                      },
                    )
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 250),
                    child: Image.asset(
                      'assets/images/logo_horizone.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 430,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Color(0xffF6F1EB),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context). size.width * 0.8,
                            child: Text(
                              'Ready to explore beyond boundaries?',
                              style: TextStyle(
                                fontSize: 32,
                                color: Color(0xff003566),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/profileSetUp'
                                    );
                                  },
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
