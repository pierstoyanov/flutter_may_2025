import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/bottom_navigation_bar_provider.dart';
import 'package:flutter_application_1/widgets/my_app_bar.dart';
import 'package:flutter_application_1/widgets/my_bottom_navigation_bar.dart';
import 'package:flutter_application_1/providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  final String title;
  const SettingsScreen({super.key, required this.title});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late ThemeMode _currentMode;

  @override
  void initState() {
    super.initState();
    loadThemeData();
  }

  void loadThemeData() {
    final mode = context.read<ThemeProvider>().themeMode;
    setState(() {
      _currentMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navbarProvider = context.watch<BottomNavigationBarProvider>();
    return Scaffold(
      appBar: MyAppBar(title: widget.title),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Choose a theme',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _themeOption('Light', ThemeMode.light),
          _themeOption('Dark', ThemeMode.dark),
          _themeOption('Use System settings', ThemeMode.system),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: navbarProvider.currentIndex, 
        onItemSelected: (index) => navbarProvider.navigateTo(index, context)),
      );
  }

  void _onThemeChanged(ThemeMode newMode) {
    context.read<ThemeProvider>().setTheme(newMode);
    setState(() => _currentMode = newMode);
  }

  Widget _themeOption(String label, ThemeMode mode) {
    return RadioListTile<ThemeMode>(
      title: Text(label),
      value: mode,
      groupValue: _currentMode,
      onChanged: (val) => _onThemeChanged(val!),
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }
}
