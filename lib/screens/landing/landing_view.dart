import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/landing/landing_page.dart';
import 'package:flutter_application_1/widgets/month_callendar/month_callendar.dart';

class LandingView extends StatelessWidget {
  final LandingPageState state;
  const LandingView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: MonthCalendar(
            initialDate: state.selectedDate,
            onDateSelected: state.onDateSelected,   
            selectedDayColor: Colors.purple,
            todayColor: Colors.orange,
            dayTextColor: Colors.black87,
            weekendTextColor: Colors.red,
            headerTextColor: Colors.deepPurple,
            dayFontSize: 16.0,
            headerFontSize: 18.0,
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            color: Colors.amber,
            height: 250,
          )
        ),
      ]
    );
  }
}