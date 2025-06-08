import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/providers/bottom_navigation_bar_provider.dart';
import 'package:flutter_application_1/widgets/my_app_bar.dart';
import 'package:flutter_application_1/widgets/my_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String title;
  const ProfileScreen({super.key, required this.title});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  StreamSubscription<User?>? _authStateSubscription;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    });
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final navbarProvider = context.watch<BottomNavigationBarProvider>();
    return Scaffold(
      appBar: MyAppBar(title: widget.title),
      body: Center(
        child: _currentUser == null
            ? ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/auth');
                },
                child: const Text('Login / Register'),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome, ${_currentUser!.email ?? 'User'}!'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Logout'),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        currentIndex: navbarProvider.currentIndex,
        onItemSelected: (index) => navbarProvider.navigateTo(index, context),
      ),
    );
  }
}
