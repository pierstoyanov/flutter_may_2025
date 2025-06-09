import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/calendar_provider.dart';

class DayViewWidget extends StatelessWidget {
  final double hourRowHeight;

  const DayViewWidget({
    super.key,
    this.hourRowHeight = 60.0, 
  });

  @override
  Widget build(BuildContext context) {
    final calendarProvider = context.watch<CalendarProvider>();
    final DateTime? selectedDay = calendarProvider.selectedDate;
    final theme = Theme.of(context);

    if (selectedDay == null) {
      // Handle case where no day is selected, perhaps show today or a message
      return const Center(child: Text("Please select a day from the calendar."));
    }

    return Column(
      children: [
        // Day navigation header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  calendarProvider.goToPreviousDay();
                },
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMMEEEEd().format(selectedDay),
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  calendarProvider.goToNextDay();
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Hourly slots
        Expanded(
          child: ListView.builder(
            itemCount: 24,
            itemBuilder: (context, hour) {
              return Container(
                height: hourRowHeight,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: theme.dividerColor, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    // Hour Label
                    Container(
                      width: 60, // Fixed width for hour labels
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      alignment: Alignment.topCenter,
                      child: Text(
                        '${hour.toString().padLeft(2, '0')}:00',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    const VerticalDivider(width: 1, thickness: 0.5),
                    // Event Area for this hour (placeholder for now)
                    Expanded(
                      child: Container(
                          // TODO: Add logic to display events for this hour
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}