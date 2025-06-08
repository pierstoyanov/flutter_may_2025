import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/bottom_navigation_bar_provider.dart';
import 'package:flutter_application_1/widgets/my_app_bar.dart';
import 'package:flutter_application_1/widgets/my_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/widgets/create_event_fab.dart';

class EventsScreen extends StatefulWidget {
  final String title;
  const EventsScreen({super.key, required this.title});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {

  @override
  Widget build(BuildContext context) {
    final navbarProvider = context.watch<BottomNavigationBarProvider>();

    return Scaffold(
      appBar: MyAppBar(title: widget.title),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
            // TODO: Implement a list of all events or filtered events here
            const Center(child: Text("All events will be listed here.")),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: navbarProvider.currentIndex, 
        onItemSelected: (index) => navbarProvider.navigateTo(index, context)),
        floatingActionButton: const CreateEventFAB(),
      );
  }
}
