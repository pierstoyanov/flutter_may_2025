import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/calendar_provider.dart';
import 'package:flutter_application_1/widgets/month_calendar/month_calendar_carousel.dart';

class MonthCalendar extends StatelessWidget{
  const MonthCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarProvider>(
      builder: (context, calendarProvider, child){
        return  Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20,
            bottom: 10
          ),
          child: MonthCalendarCarousel(
            initialDate: calendarProvider.currentMonth, // Initial month for PageController
            onDateSelected: (date) {
              // This callback is now for external listeners, as provider handles internal state
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Globally Selected: ${date.toLocal().toString().split(' ')[0]}')),
              );
            })
        );
      }
    );
  }
}
