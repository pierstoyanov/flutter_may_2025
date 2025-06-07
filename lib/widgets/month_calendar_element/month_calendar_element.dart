import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthCalendarElement extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime>? onDateSelected;
  final Color? selectedDayColor;
  final Color? todayColor;
  final Color? dayTextColor;
  final Color? weekendTextColor;
  final Color? headerTextColor;
  final double? dayFontSize;
  final double? headerFontSize;

  const MonthCalendarElement({
    Key? key,
    required this.initialDate,
    this.onDateSelected,
    this.selectedDayColor,
    this.todayColor,
    this.dayTextColor,
    this.weekendTextColor,
    this.headerTextColor,
    this.dayFontSize,
    this.headerFontSize,
  }) : super(key: key);

  @override
  _MonthCalendarElementState createState() => _MonthCalendarElementState();
}

class _MonthCalendarElementState extends State<MonthCalendarElement> {
  late DateTime _displayedMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(widget.initialDate.year, widget.initialDate.month, 1);
    _selectedDate = widget.initialDate;
  }

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

  // Helper to get the weekday of the first day of the month (0 for Sunday, 6 for Saturday)
  int _getWeekdayOfFirstDay(DateTime month) {
    return _getFirstDayOfMonth(month).weekday % 7; // Adjust for Monday = 1 in Dart's DateTime.weekday
  }

  // Builds a single day cell
  Widget _buildDayCell(int day, bool isCurrentMonth) {
    final DateTime today = DateTime.now();
    final DateTime currentDate =
        DateTime(_displayedMonth.year, _displayedMonth.month, day);
    final bool isToday = currentDate.year == today.year &&
        currentDate.month == today.month &&
        currentDate.day == today.day;
    final bool isSelected = _selectedDate != null &&
        currentDate.year == _selectedDate!.year &&
        currentDate.month == _selectedDate!.month &&
        currentDate.day == _selectedDate!.day;
    final bool isWeekend =
        currentDate.weekday == DateTime.saturday || currentDate.weekday == DateTime.sunday;

    Color? textColor = widget.dayTextColor;
    if (!isCurrentMonth) {
      textColor = textColor?.withOpacity(0.4) ?? Colors.grey.withOpacity(0.4); // Dim out days from other months
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
          setState(() {
            _selectedDate = currentDate;
          });
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
      ),
    );
  }

  // Builds the header row with day names
  Widget _buildWeekdayHeader() {
    final List<String> weekdays = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat'
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

  void _goToPreviousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
      _selectedDate = null; // Clear selection when changing month
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
      _selectedDate = null; // Clear selection when changing month
    });
  }

  @override
  Widget build(BuildContext context) {
    final int firstDayWeekday = _getWeekdayOfFirstDay(_displayedMonth); // 0 for Sunday, 6 for Saturday
    final int daysInMonth = _getNumberOfDaysInMonth(_displayedMonth);

    // Calculate the number of empty cells at the beginning
    final int leadingEmptyCells = firstDayWeekday;

    // Calculate days from the previous month to fill leading empty cells
    final DateTime lastDayOfPreviousMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 0);
    final int daysInPreviousMonth = lastDayOfPreviousMonth.day;
    final List<Widget> previousMonthDays = List.generate(leadingEmptyCells, (index) {
      final int day = daysInPreviousMonth - leadingEmptyCells + 1 + index;
      return _buildDayCell(day, false); // false for not current month
    });


    final List<Widget> currentMonthDays = List.generate(daysInMonth, (index) {
      return _buildDayCell(index + 1, true);
    });

    // Calculate total number of cells needed (rows * 7 columns, minimum 6 rows for full month view)
    final int totalCells = leadingEmptyCells + daysInMonth;
    final int trailingEmptyCells = (7 - (totalCells % 7)) % 7; // Ensures a full grid of 7 columns

    // Days from the next month to fill trailing empty cells
    final List<Widget> nextMonthDays = List.generate(trailingEmptyCells, (index) {
      return _buildDayCell(index + 1, false); // false for not current month
    });

    final List<Widget> allDayCells = [
      ...previousMonthDays,
      ...currentMonthDays,
      ...nextMonthDays,
    ];

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month navigation header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: _goToPreviousMonth,
              ),
              Text(
                DateFormat.yMMMM().format(_displayedMonth),
                style: TextStyle(
                  fontSize: widget.headerFontSize != null ? widget.headerFontSize! + 4 : 20,
                  fontWeight: FontWeight.bold,
                  color: widget.headerTextColor ?? Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: _goToNextMonth,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildWeekdayHeader(),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling in the grid
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0, // Make cells square
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