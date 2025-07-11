import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../state/theme_provider.dart';

class ProfileSetUpScreen extends StatefulWidget {
  const ProfileSetUpScreen({super.key});

  @override
  State<ProfileSetUpScreen> createState() => _ProfileSetUpScreenState();
}

class _ProfileSetUpScreenState extends State<ProfileSetUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).primaryColor,

        actionsIconTheme: IconThemeData(size: 30),
        centerTitle: true,
        title: Text(
          S.of(context).profile,
          style: TextStyle(
            color: Theme.of(context).hintColor,
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
        actions: [
          IconButton(
              onPressed: () {
                final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                themeProvider.toggleTheme(!themeProvider.isDarkMode);
              },
              icon: Icon(Icons.light_mode))
        ],
      ),

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileInfoText(
                        tellUs: S.of(context).tellUs,
                        whoYouAre: S.of(context).whoYouAre,
                        andWellTake: S.of(context).andWellTake,
                      ), SizedBox(height: 24),
                      OrangeTextForm(nameButton: S.of(context).name, icon: Icons.person,),
                      SizedBox(height: 18),
                      OrangeTextBoxForm(
                        nameButton: S.of(context).bio,
                        hintText: S.of(context).bioDescription,
                        icon: Icons.info_outline,
                      ),
                      SizedBox(height: 18),
                      DatePickerTextFormField(
                        nameButton: S.of(context).dateOfBirth,
                      ),
                      SizedBox(height: 18),
                      OrangeTextForm(nameButton: S.of(context).gender, icon: Icons.person_outline,),
                      SizedBox(height: 18),
                      OrangeTextForm(nameButton: S.of(context).jobTitle, icon: Icons.work_outline),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(22),
        child: ContinueButton(
          title: S.of(context).continueButton,
          pathRoute: "/getStarted",
        ),
      ),
    );
  }
}

// This widget is a text form field with an orange border and label.
class OrangeTextForm extends StatelessWidget {
  const OrangeTextForm({required this.nameButton, required this.icon, super.key});

  final String nameButton;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Theme.of(context).primaryColor),
      decoration: InputDecoration(
        labelText: nameButton,
        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
        prefixIcon: Align(widthFactor: 1.0, heightFactor: 1.0, child: Icon(icon, size: 20, color: Theme.of(context).hintColor,)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
        ),
      ),
    );
  }
}

// This widget is a text box that allows multiline input with a hint text.
class OrangeTextBoxForm extends StatelessWidget {
  const OrangeTextBoxForm({
    required this.hintText,
    required this.nameButton,
    required this.icon,
    super.key,
  });

  final String nameButton;
  final String hintText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: TextFormField(
        maxLines: null,
        expands: true,
        keyboardType: TextInputType.multiline,
        style: TextStyle(color: Theme.of(context).primaryColor),
        decoration: InputDecoration(
          labelText: nameButton,
          hintText: hintText,
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          hintStyle: TextStyle(color: Theme.of(context).primaryColor.withOpacity(0.5) ),
          prefixIcon: Align(widthFactor: 1.0, heightFactor: 1.0, child: Icon(icon, size: 20, color: Theme.of(context).hintColor,)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Theme.of(context).hintColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Theme.of(context).hintColor),
          ),
        ),
      ),
    );
  }
}

class DatePickerTextFormField extends StatefulWidget {
  const DatePickerTextFormField({required this.nameButton, super.key});

  final String nameButton;

  @override
  State<DatePickerTextFormField> createState() =>
      _DatePickerTextFormFieldState();
}

class _DatePickerTextFormFieldState extends State<DatePickerTextFormField> {
  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).hintColor,
            hintColor: Theme.of(context).primaryColor,
            colorScheme: ColorScheme.light(primary: Theme.of(context).hintColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: selectedDate != null
          ? selectedDate!
          : DateTime.now().subtract(Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(Duration(days: 365 * 18)),
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).hintColor),
          color: Colors.transparent,
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.date_range_outlined, size: 20, color: Theme.of(context).hintColor,),
            SizedBox(width: 10),
            Text(
              selectedDate != null
                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                  : widget.nameButton,
              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
            ),
          ],
        ),
      ),
      onTap: () => {_selectDate()},
    );
  }
}

// This widget is a button that navigates to the next screen when pressed.
class ContinueButton extends StatelessWidget {
  const ContinueButton({
    required this.title,
    required this.pathRoute,
    super.key,
  });

  final String title;
  final String pathRoute;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 52, vertical: 16),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).highlightColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// This widget displays the introductory text on the Profile Setup screen.
class ProfileInfoText extends StatelessWidget {
  const ProfileInfoText({
    required this.tellUs,
    required this.whoYouAre,
    required this.andWellTake,
    super.key,
  });

  final String tellUs;
  final String whoYouAre;
  final String andWellTake;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor),
        children: [
          TextSpan(text: tellUs),
          TextSpan(
            text: whoYouAre,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          TextSpan(
            text: andWellTake,
            style: TextStyle(overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
