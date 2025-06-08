import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/bottom_navigation_bar_provider.dart';
import 'package:flutter_application_1/widgets/event_widget.dart';
import 'package:flutter_application_1/widgets/my_app_bar.dart';
import 'package:flutter_application_1/widgets/my_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/widgets/month_callendar/month_calendar.dart';


class LandingPage extends StatefulWidget {
  final String title;
  const LandingPage({super.key, required this.title});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    // Use 'watch' to rebuild if currentIndex changes.
    final navbarProvider = context.watch<BottomNavigationBarProvider>();
    return Scaffold(
      appBar: MyAppBar(title: widget.title), // widget.title refers to "Calendar"
      body: ListView(
        children: const [
          MonthCalendar(), // Displays the swipeable month calendar
          DailyEventsWidget(), // Display the events for the selected day
      ]),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: navbarProvider.currentIndex,
        onItemSelected: (index) => navbarProvider.navigateTo(index, context),
      ),
    );
  }
}