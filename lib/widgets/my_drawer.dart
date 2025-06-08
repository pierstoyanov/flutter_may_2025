import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/bottom_navigation_bar_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final navbarProvider = Provider.of<BottomNavigationBarProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              'Calendar App Menu',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_view_month),
            title: const Text('Month View'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              navbarProvider.navigateTo(0, context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_view_week),
            title: const Text('Week View'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/week-view', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}