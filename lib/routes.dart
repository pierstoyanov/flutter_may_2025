import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/bottom_navigation_bar_provider.dart';
import 'package:flutter_application_1/screens/landing_page.dart';
import 'package:flutter_application_1/screens/profile_page.dart';
import 'package:flutter_application_1/screens/settings_screen.dart';
import 'package:flutter_application_1/widgets/my_app_bar.dart';
import 'package:flutter_application_1/widgets/my_bottom_navigation_bar.dart';
import 'package:flutter_application_1/screens/auth_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (_) => const LandingPage(title: 'Calendar'),
  '/settings': (_) => const SettingsScreen(title: 'Settings'),
  '/tasks': (_) => const PlaceholderScreen(title: 'Tasks'),
  '/profile': (_) => const ProfileScreen(title: 'Profile'), // Changed to ProfileScreen
  '/auth': (_) => const AuthScreen(), // New route for authentication
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
