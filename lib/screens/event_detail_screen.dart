import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/event_item.dart';
import 'package:flutter_application_1/widgets/my_app_bar.dart';
import 'package:flutter_application_1/data/event_repository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatelessWidget {
  final EventItem event;
  final String title;

  const EventDetailScreen({
    super.key,
    required this.event,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final eventRepository = Provider.of<EventRepository>(context, listen: false);

    return Scaffold(
      appBar: MyAppBar(title: title),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'From: ${DateFormat.yMMMd().add_jm().format(event.startTime)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'To: ${DateFormat.yMMMd().add_jm().format(event.endTime)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              event.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            if (currentUser != null && currentUser.uid == event.createdBy)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    onPressed: () {
                      // TODO: Implement navigation to an EditEventScreen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit functionality not yet implemented.')),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                    label: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    onPressed: () async {
                      final confirmDelete = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text('Are you sure you want to delete this event?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error))),
                          ],
                        ),
                      );
                      if (confirmDelete == true) {
                        await eventRepository.deleteEvent(event.id);
                        if (context.mounted) Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}