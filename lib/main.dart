import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/calendar_provider.dart';
import 'package:flutter_application_1/screens/landing/landing_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: ChangeNotifierProvider(
          create: (context) => CalendarProvider(DateTime.now()),
          child: const LandingPage(title: 'Calendar'),
        ), 
    );
  }
}
