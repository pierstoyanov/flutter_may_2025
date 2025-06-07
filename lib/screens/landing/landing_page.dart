import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/landing/landing_view.dart';

class LandingPage extends StatefulWidget{
  const LandingPage({super.key, required this.title});
  final String title;
 

  @override
  State<LandingPage> createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  DateTime _selectedDate = DateTime.now();
  
  DateTime get selectedDate {
    return _selectedDate;
  }

  void onDateSelected(date) {
    setState(() {
      _selectedDate = date;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: ${date.toLocal().toString().split(' ')[0]}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LandingView(this);
  }
}