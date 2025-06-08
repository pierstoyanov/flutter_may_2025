import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/calendar_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; 

class WeekCalendar extends StatelessWidget {
  const WeekCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarProvider = context.watch<CalendarProvider>();
    final DateTime startOfWeek = calendarProvider.focusedWeekStartDate;
    final DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    return SingleChildScrollView(
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        columnWidths: const {
          0: FixedColumnWidth(50.0),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FlexColumnWidth(),
          4: FlexColumnWidth(),
          5: FlexColumnWidth(),
          6: FlexColumnWidth(),
          7: FlexColumnWidth(),
        },
        children: [
          // Header row for days of the week
          _buildHeaderRow(startOfWeek),
          // Rows for each hour of the day
          ..._buildHourRows(),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow(DateTime startOfWeek) {
    List<Widget> dayHeaders = [
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: const Text(
          '', // Empty corner for hour column
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    ];

    for (int i = 0; i < 7; i++) {
      final DateTime day = startOfWeek.add(Duration(days: i));
      dayHeaders.add(
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            DateFormat('EEE\nMMM d').format(day),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return TableRow(children: dayHeaders);
  }

  List<TableRow> _buildHourRows() {
    List<TableRow> hourRows = [];
    for (int hour = 0; hour < 24; hour++) {
      List<Widget> cells = [
        Container(
          alignment: Alignment.topRight, // Align hour to top right
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            '${hour.toString().padLeft(2, '0')}:00',
            style: const TextStyle(fontSize: 12.0, color: Colors.grey),
          ),
        ),
      ];
      // 7 columns for days
      for (int i = 0; i < 7; i++) {
        cells.add(
          Container(
            height: 60.0, // Adjust height as needed for each hour slot
            padding: const EdgeInsets.all(4.0),
            alignment: Alignment.topLeft,
            child: const Text(''), // Placeholder for events
          ),
        );
      }
      hourRows.add(TableRow(children: cells));
    }
    return hourRows;
  }
}