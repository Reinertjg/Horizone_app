import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

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
        backgroundColor: Color(0xffF6F1EB),
        foregroundColor: Color(0xff003566),

        actionsIconTheme: IconThemeData(size: 30),
        centerTitle: true,
        title: Text(
          S.of(context).profile,
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
                      ),
                      SizedBox(height: 24),
                      OrangeTextForm(nameButton: S.of(context).name),
                      SizedBox(height: 18),
                      OrangeTextBoxForm(
                        nameButton: S.of(context).bio,
                        hintText: S.of(context).bioDescription,
                      ),
                      SizedBox(height: 18),
                      DatePickerTextFormField(nameButton: S.of(context).dateOfBirth),
                      SizedBox(height: 18),
                      OrangeTextForm(nameButton: S.of(context).gender),
                      SizedBox(height: 18),
                      OrangeTextForm(nameButton: S.of(context).jobTitle),
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
  const OrangeTextForm({required this.nameButton, super.key});

  final String nameButton;

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

// This widget is a text box that allows multiline input with a hint text.
class OrangeTextBoxForm extends StatelessWidget {
  const OrangeTextBoxForm({
    required this.hintText,
    required this.nameButton,
    super.key,
  });

  final String nameButton;
  final String hintText;

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

class DatePickerTextFormField extends StatefulWidget {
  DatePickerTextFormField({required this.nameButton, super.key}) {
    // TODO: implement DatePickerTextFormField
    throw UnimplementedError();
  }

  final String nameButton;

  @override
  State<DatePickerTextFormField> createState() =>
      _DatePickerTextFormFieldState();
}

class _DatePickerTextFormFieldState extends State<DatePickerTextFormField> {
  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
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
          border: Border.all(color: Color(0xffFF914D)),
          color: Colors.transparent,
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate != null
                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                  : widget.nameButton,
              style: TextStyle(color: Color(0xff020101), fontSize: 16),
            ),
            Icon(Icons.date_range_outlined,)
          ],
        ),
      ),
      onTap: () => {_selectDate()},
    );
  }
}

// This widget is a button that navigates to the next screen when pressed.
class ContinueButton extends StatelessWidget {
  const ContinueButton({required this.title, required this.pathRoute, super.key});

  final String title;
  final String pathRoute;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff003566),
        padding: EdgeInsets.symmetric(horizontal: 52, vertical: 16),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
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
        style: TextStyle(fontSize: 16, color: Color(0xffFF914D)),
        children: [
          TextSpan(text: tellUs),
          TextSpan(
            text: whoYouAre,
            style: TextStyle(color: Color(0xff003566)),
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

class _DatePickerExampleState extends StatefulWidget {
  @override
  State<_DatePickerExampleState> createState() =>
      _DatePickerExampleStateState();
}

class _DatePickerExampleStateState extends State<_DatePickerExampleState> {
  DateTime? selectedDate;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2021, 7, 25),
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
    );

    setState(() {
      selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: <Widget>[
        Text(
          selectedDate != null
              ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
              : 'No date selected',
        ),
        OutlinedButton(
          onPressed: _selectDate,
          child: const Text('Select Date'),
        ),
      ],
    );
  }
}
