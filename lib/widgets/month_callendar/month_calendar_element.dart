import 'package:flutter/material.dart';

class MonthCalendarElement extends StatefulWidget {
  final DateTime initialDate;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final Function(double height)? onHeightDetermined; // Callback to report height
  final Color? selectedDayColor;
  final Color? todayColor;
  final Color? dayTextColor;
  final Color? weekendTextColor;
  final Color? headerTextColor;
  final double? dayFontSize;
  final double? headerFontSize;

  const MonthCalendarElement({
    super.key,
    required this.initialDate, // This is the month to show
    this.onDateSelected,
    this.onHeightDetermined,
    this.selectedDate, // Now passed from the provider
    this.selectedDayColor,
    this.todayColor,
    this.dayTextColor,
    this.weekendTextColor,
    this.headerTextColor,
    this.dayFontSize,
    this.headerFontSize,
  });

  @override
  MonthCalendarElementState createState() => MonthCalendarElementState();
}

class MonthCalendarElementState extends State<MonthCalendarElement> {
  // Helper to get the first day of the month
  DateTime _getFirstDayOfMonth(DateTime month) {
    return DateTime(month.year, month.month, 1);
  }

  // Helper to get the last day of the month
  DateTime _getLastDayOfMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0); // Day 0 of next month is last day of current month
  }

  // Helper to get the number of days in the month
  int _getNumberOfDaysInMonth(DateTime month) {
    return _getLastDayOfMonth(month).day;
  }

  // Helper to get the weekday of the first day of the month (0 for Monday, 6 for Sunday)
  int _getWeekdayOfFirstDay(DateTime month) {
    final DateTime firstDay = _getFirstDayOfMonth(month);
    // DateTime.weekday returns 1 for Monday, ..., 7 for Sunday.
    // To make Monday 0, Tuesday 1, ..., Sunday 6, we subtract 1.
    return firstDay.weekday - 1;
  }

  // Builds a single day cell
  Widget _buildDayCell(int day, bool isCurrentMonth) {
    final DateTime today = DateTime.now();
    final DateTime currentDate =
        DateTime(widget.initialDate.year, widget.initialDate.month, day);
    final bool isToday = currentDate.year == today.year &&
        currentDate.month == today.month &&
        currentDate.day == today.day;
    // Check against the selectedDate passed from the provider
    final bool isSelected = widget.selectedDate != null &&
        currentDate.year == widget.selectedDate!.year &&
        currentDate.month == widget.selectedDate!.month &&
        currentDate.day == widget.selectedDate!.day;
    final bool isWeekend =
        currentDate.weekday == DateTime.saturday || currentDate.weekday == DateTime.sunday;

    Color? textColor = widget.dayTextColor;
    if (!isCurrentMonth) {
      textColor = Colors.grey; // Dim out days from other months
    } else if (isWeekend) {
      textColor = widget.weekendTextColor ?? Colors.red;
    }

    BoxDecoration? decoration;
    if (isSelected) {
      decoration = BoxDecoration(
        color: widget.selectedDayColor ?? Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      );
      textColor = Colors.white; // White text for selected day
    } else if (isToday) {
      decoration = BoxDecoration(
        border: Border.all(color: widget.todayColor ?? Colors.blue, width: 2),
        shape: BoxShape.circle,
      );
    }

    return GestureDetector(
      onTap: () {
        if (isCurrentMonth) {
          // Call the callback to notify the provider
          widget.onDateSelected?.call(currentDate);
        }
      },
      child: Container(
        decoration: decoration,
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: TextStyle(
            color: textColor,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            fontSize: widget.dayFontSize,
          ),
        ),
      )
    );
    }

    // Builds the header row with day names (Modified for Monday start)
    Widget _buildWeekdayHeader() {
      final List<String> weekdays = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun'
      ];
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weekdays
            .map(
              (day) => Expanded(
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.headerTextColor ?? Colors.blueGrey,
                    fontSize: widget.headerFontSize,
                  ),
                ),
              ),
            )
            .toList(),
      );
    }

    @override
    Widget build(BuildContext context) {
      // Report height after layout
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.onHeightDetermined != null) {
          final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null && renderBox.hasSize && renderBox.size.height > 0) {
            // Check if the height has actually changed to avoid unnecessary calls
            // This simple check might need more sophisticated handling if rapid small changes occur.
            widget.onHeightDetermined!(renderBox.size.height);
          }
        }
      });

      final int firstDayWeekday = _getWeekdayOfFirstDay(widget.initialDate);
      final int daysInMonth = _getNumberOfDaysInMonth(widget.initialDate);

      final int leadingEmptyCells = firstDayWeekday;

      final DateTime lastDayOfPreviousMonth = DateTime(widget.initialDate.year, widget.initialDate.month, 0);
      final int daysInPreviousMonth = lastDayOfPreviousMonth.day;
      final List<Widget> previousMonthDays = List.generate(leadingEmptyCells, (index) {
        final int day = daysInPreviousMonth - leadingEmptyCells + 1 + index;
        return _buildDayCell(day, false);
      });

      final List<Widget> currentMonthDays = List.generate(daysInMonth, (index) {
        return _buildDayCell(index + 1, true);
      });

      final int totalCells = leadingEmptyCells + daysInMonth;
      final int trailingEmptyCells = (7 - (totalCells % 7)) % 7;

      final List<Widget> nextMonthDays = List.generate(trailingEmptyCells, (index) {
        return _buildDayCell(index + 1, false);
      });

      final List<Widget> allDayCells = [
        ...previousMonthDays,
        ...currentMonthDays,
        ...nextMonthDays,
      ];

      return Container(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildWeekdayHeader(),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: allDayCells.length,
              itemBuilder: (context, index) {
                return allDayCells[index];
              },
            ),
          ],
        ),
      );
  }
}