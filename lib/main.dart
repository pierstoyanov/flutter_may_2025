import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_application_1/routes.dart' show appRoutes;
import 'package:flutter_application_1/data/event_repository.dart';
import 'package:flutter_application_1/theme/app_theme.dart';
import 'package:flutter_application_1/providers/bottom_navigation_bar_provider.dart';
import 'package:flutter_application_1/providers/calendar_provider.dart';
import 'package:flutter_application_1/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> ThemeProvider()),
        ChangeNotifierProvider(create: (_)=> BottomNavigationBarProvider()),
        ChangeNotifierProvider(create: (_)=> CalendarProvider(DateTime.now())),
        ChangeNotifierProvider(
          create: (_) => EventRepository(
            auth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: appRoutes,
          );
        }
      )
    );
  }
}
    