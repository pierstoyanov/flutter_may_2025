import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/calendar_provider.dart';
import 'package:flutter_application_1/widgets/month_callendar_carousel/month_calendar_carousel.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  final String title;
  const LandingPage({super.key, required this.title});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          )
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: MonthCalendarCarousel(
              initialDate: calendarProvider.currentMonth, // Initial month for PageController
              onDateSelected: (date) {
                // This callback is now for external listeners, as provider handles internal state
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Globally Selected: ${date.toLocal().toString().split(' ')[0]}')),
                );
              })
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              color: Colors.amber,
              height: 250,
            )
          ),
      ])
    );
  }
}