import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/calendar_provider.dart';
import 'package:flutter_application_1/data/event_repository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyEventsWidget extends StatelessWidget {
  const DailyEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<CalendarProvider, EventRepository>(
      builder: (context, calendarProvider, eventRepository, child) {
        final selectedDate = calendarProvider.selectedDate;
        final allEvents = eventRepository.events;

        final eventsForSelectedDay = allEvents.where((event) {
          // Compare year, month, and day of event's startTime with selectedDate
          return event.startTime.year == selectedDate?.year &&
                 event.startTime.month == selectedDate?.month &&
                 event.startTime.day == selectedDate?.day;
        }).toList();

        // Sort events by start time
        eventsForSelectedDay.sort((a, b) => a.startTime.compareTo(b.startTime));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Events for ${DateFormat.yMMMMd().format(selectedDate!)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              if (eventRepository.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (eventsForSelectedDay.isEmpty)
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Text(
                    'No events for this day.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true, // Important for ListView inside Column
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: eventsForSelectedDay.length,
                  itemBuilder: (ctx, index) {
                    final event = eventsForSelectedDay[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        title: Text(event.title),
                        subtitle: Text(
                          '${DateFormat.jm().format(event.startTime)} - ${DateFormat.jm().format(event.endTime)}',
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/event-detail',
                            arguments: event,
                          );
                        },
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}