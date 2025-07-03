import 'package:flutter/material.dart';

class ProfileSetUpScreen extends StatefulWidget {
  const ProfileSetUpScreen({super.key});

  @override
  State<ProfileSetUpScreen> createState() => _ProfileSetUpScreenState();
}

class _ProfileSetUpScreenState extends State<ProfileSetUpScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6F1EB),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 36.0, left: 12.0, right: 12.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/getStarted');
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Color(0xff003566),
                      size: 30,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      color: Color(0xffFF914D),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(34.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 16, color: Color(0xffFF914D)),
                      children: [
                        TextSpan(text: 'Tell Us '),
                        TextSpan(
                          text: 'Who You Are \n',
                          style: TextStyle(color: Color(0xff003566)),
                        ),
                        TextSpan(
                          text: 'And We\'ll Take You Where \nYou Want to Be',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18),
                  OrangeTextForm(nameButton: 'Name'),
                  SizedBox(height: 18),
                  OrangeTextBoxForm(
                    hintText:
                        'Bio \n \nI am a Flutter developer at Lince Tech, creating fast and elegant mobile apps.',
                  ),
                  SizedBox(height: 18),
                  OrangeTextForm(nameButton: 'Date'),
                  SizedBox(height: 18),
                  OrangeTextForm(nameButton: 'Gender'),
                  SizedBox(height: 18),
                  OrangeTextForm(nameButton: 'Job Title'),
                  SizedBox(height: 100,),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context,
                          '/getStarted'
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff003566),
                      padding: EdgeInsets.symmetric(horizontal: 52, vertical: 16),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrangeTextForm extends StatelessWidget {
  OrangeTextForm({required this.nameButton, super.key});

  String nameButton = 'Click Me';

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: nameButton,
        labelStyle: TextStyle(color: Color(0xff020101)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xffFF914D)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xffFF914D)),
        ),
      ),
    );
  }
}

class OrangeTextBoxForm extends StatelessWidget {
  OrangeTextBoxForm({required this.hintText, super.key});

  String hintText = 'Hint Text';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125, //     <-- TextField expands to this height.
      child: TextFormField(
        maxLines: null, // Set this
        expands: true, // and this
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          hintText: hintText,
          labelStyle: TextStyle(color: Color(0xff020101)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xffFF914D)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Color(0xffFF914D)),
          ),
        ),
      ),
    );
  }
}
