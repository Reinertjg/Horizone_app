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
      appBar: AppBar(
        backgroundColor: Color(0xffF6F1EB),
        foregroundColor: Color(0xff003566),

        actionsIconTheme: IconThemeData(size: 30),
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Color(0xffFF914D),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.pushNamed(context, '/getStarted'); // Default back action
          },
        ),
      ),

      backgroundColor: Color(0xffF6F1EB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  right: 35,
                  bottom: 35,
                  left: 35,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xffFF914D),
                        ),
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
                      nameButton: 'Bio',
                      hintText:
                          'I am a Flutter developer at Lince Tech, creating fast and elegant mobile apps.',
                    ),
                    SizedBox(height: 18),
                    OrangeTextForm(nameButton: 'Date'),
                    SizedBox(height: 18),
                    OrangeTextForm(nameButton: 'Gender'),
                    SizedBox(height: 18),
                    OrangeTextForm(nameButton: 'Job Title'),
                    SizedBox(height: 100),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/getStarted');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff003566),
                        padding: EdgeInsets.symmetric(
                          horizontal: 52,
                          vertical: 16,
                        ),
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
  OrangeTextBoxForm({
    required this.hintText,
    required this.nameButton,
    super.key,
  });

  String nameButton = 'Click me';
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
          labelText: nameButton,
          hintText: hintText,
          labelStyle: TextStyle(color: Color(0xff020101), ),
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
