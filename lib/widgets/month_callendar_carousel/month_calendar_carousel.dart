import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/callendar_provider.dart';
import 'package:flutter_application_1/widgets/month_calendar_element/month_calendar_element.dart';

class MonthCalendarCarouselScreen extends StatefulWidget {
  // This widget handles horisontal swiping of Month Callendar Elemnents
  const MonthCalendarCarouselScreen({Key? key}) : super(key: key);

  @override
  State<MonthCalendarCarouselScreen> createState() => _MonthCalendarCarouselScreenState();
}

class _MonthCalendarCarouselScreenState extends State<MonthCalendarCarouselScreen> {
  DateTime _currentlySelectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // You can listen to the selected date from the provider here if needed globally
    final calendarProvider = Provider.of<CalendarProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: MonthCalendarElement(
        initialDate: calendarProvider.currentMonth, // Initial month for PageController
        onDateSelected: (date) {
          // This callback is now for external listeners, as provider handles internal state
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Globally Selected: ${date.toLocal().toString().split(' ')[0]}')),
          );
        },
        selectedDayColor: Colors.deepOrange,
        todayColor: Colors.teal,
        dayTextColor: Colors.brown,
        weekendTextColor: Colors.redAccent,
        headerTextColor: Colors.blueGrey.shade800,
        dayFontSize: 15.0,
        headerFontSize: 17.0,
      ),
    );
  }
}