import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/my_app_bar.dart';
import 'package:flutter_application_1/widgets/my_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/bottom_navigation_bar_provider.dart';
import 'package:flutter_application_1/widgets/day_view_widget.dart';

class DayViewScreen extends StatelessWidget {
  final String title;
  const DayViewScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final navbarProvider = context.watch<BottomNavigationBarProvider>();
    return Scaffold(
      appBar: MyAppBar(title: title),
      body: const DayViewWidget(), 
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: navbarProvider.currentIndex, 
        onItemSelected: (index) => navbarProvider.navigateTo(index, context),
      ),
    );
  }
}