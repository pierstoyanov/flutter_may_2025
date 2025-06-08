import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateEventFAB extends StatelessWidget {
  final Object? heroTag; // Add heroTag parameter
  const CreateEventFAB({super.key, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return FloatingActionButton(
      onPressed: () {
        if (currentUser != null) {
          Navigator.pushNamed(context, '/create-event');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Only logged in users can create events.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      tooltip: 'Create Event',
      child: const Icon(Icons.add),
    );
  }
}