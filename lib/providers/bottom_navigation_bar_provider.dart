import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart'; // Required for Navigator

class BottomNavigationBarProvider with ChangeNotifier{
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  String _getRouteName(int index) {
    switch (index) {
      case 0: return '/'; // LandingPage
      case 1: return '/events';
      case 2: return '/profile';
      case 3: return '/settings';
      case 4: return '/login';
      default: return ''; // Should not happen with a fixed number of tabs
    }
  }

  void navigateTo(int index, BuildContext context) {
    // Prevent reloading the same screen on multiple taps
    if (_currentIndex == index && ModalRoute.of(context)?.settings.name == _getRouteName(index)) {
      return;
    }

    _currentIndex = index;
    notifyListeners();

    final String routeName = _getRouteName(index);
    if (routeName.isNotEmpty) {
      // Navigate to the new screen and remove all previous routes.
      // This is a common pattern for bottom navigation bars.
      Navigator.pushNamedAndRemoveUntil(context, routeName, (Route<dynamic> route) => false);
    }
  }
}