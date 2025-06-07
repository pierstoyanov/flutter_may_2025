import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/callendar_provider.dart';
import 'package:flutter_application_1/screens/landing/landing_page.dart';
import 'package:flutter_application_1/widgets/month_callendar_carousel/month_calendar_carousel.dart';
import 'package:provider/provider.dart';


class LandingView extends StatelessWidget {
  final LandingPageState state;
  const LandingView(this.state, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50),
          )
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(state.widget.title),
      ),
      body: ListView(
        children: [
          ChangeNotifierProvider(
            create:(context) => CalendarProvider(DateTime.now()),
            child: const MonthCalendarCarouselScreen()
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