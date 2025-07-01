import 'package:flutter/material.dart';

class ProfileSetUpScreen extends StatelessWidget {
  const ProfileSetUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF6F1EB),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back, color: Color(0xff003566), size: 30,),
                  Expanded(child: Text('Profile', style: TextStyle(color: Color(0xffFF914D), fontSize: 28, fontWeight: FontWeight.bold),)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
