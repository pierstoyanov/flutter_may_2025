import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/register_screen.dart';
import 'package:flutter_application_1/screens/events_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/bottom_navigation_bar_provider.dart';
import 'package:flutter_application_1/screens/landing_page.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/settings_screen.dart';
import 'package:flutter_application_1/widgets/my_app_bar.dart';
import 'package:flutter_application_1/widgets/my_bottom_navigation_bar.dart';
import 'package:flutter_application_1/screens/auth_screen.dart';
import 'package:flutter_application_1/screens/event_detail_screen.dart';
import 'package:flutter_application_1/models/event_item.dart';
import 'package:flutter_application_1/screens/week_view_screen.dart';
import 'package:flutter_application_1/screens/create_event_screen.dart';
import 'package:flutter_application_1/screens/day_view_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (_) => const LandingPage(title: 'Calendar'),
  '/settings': (_) => const SettingsScreen(title: 'Settings'),
  '/events': (_) => const EventsScreen(title: 'Events'),
  '/profile': (_) => const ProfileScreen(title: 'Profile'), 
  '/auth': (_) => const AuthScreen(title: 'Login'),
  '/register': (_) => const RegisterScreen(title: 'Register'),
  '/week-view': (_) => const WeekViewScreen(title: 'Week View'),
  '/create-event': (_) => const CreateEventScreen(title: 'Create New Event'),
  '/day-view': (_) => const DayViewScreen(title: 'Day View'),
  '/event-detail': (context) {
    // Extract the event item passed as an argument
    final event = ModalRoute.of(context)!.settings.arguments as EventItem;
    return EventDetailScreen(event: event, title: 'Event Details');
  },
};
// A simple placeholder screen for routes that are not yet fully implemented.
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Use watch to rebuild if the index changes by other means (though less likely here)
    final navbarProvider = context.watch<BottomNavigationBarProvider>();
    return Scaffold(
      appBar: MyAppBar(title: title),
      body: Center(child: Text('$title Screen Content - Placeholder')),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: navbarProvider.currentIndex,
        onItemSelected: (index) => navbarProvider.navigateTo(index, context),
      ),
    );
  }
}
