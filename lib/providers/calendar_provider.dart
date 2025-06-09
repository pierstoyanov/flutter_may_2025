import 'package:flutter/material.dart';

// CalendarProvider: Manages the displayed month and selected date state
class CalendarProvider extends ChangeNotifier {
  DateTime _currentMonth;
  DateTime? _selectedDate;

  // For Week View
  DateTime _focusedWeekStartDate;

  CalendarProvider(DateTime initialDate):
    _currentMonth = DateTime(initialDate.year, initialDate.month, 1),
    _selectedDate = initialDate,
    _focusedWeekStartDate = _calculateWeekStartDate(initialDate);

  DateTime get currentMonth => _currentMonth;
  DateTime? get selectedDate => _selectedDate;
  DateTime get focusedWeekStartDate => _focusedWeekStartDate;

  static DateTime _calculateWeekStartDate(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  void goToPreviousMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    _selectedDate = null; // Clear selection when changing month
    notifyListeners();
  }

  void goToNextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    _selectedDate = null; // Clear selection when changing month
    notifyListeners();
  }

  void setCurrentMonth(DateTime month) {
    _currentMonth = DateTime(month.year, month.month, 1);
    _selectedDate = null; // clear selection on programmatic month change
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date; // Update the selected date

    // Update currentMonth if the new selectedDate is in a different month
    if (date.month != _currentMonth.month || date.year != _currentMonth.year) {
      _currentMonth = DateTime(date.year, date.month, 1);
    }

    // When a new date is selected, update the focused week to contain this date
    final newFocusedWeek = _calculateWeekStartDate(date);
    if (_focusedWeekStartDate != newFocusedWeek) {
      _focusedWeekStartDate = newFocusedWeek;
    }
    
    notifyListeners();
  }
  
  void setFocusedWeekStartDate(DateTime newWeekStartDate) {
    final weekStart = _calculateWeekStartDate(newWeekStartDate);
    if (_focusedWeekStartDate != weekStart) {
      _focusedWeekStartDate = weekStart;
      notifyListeners();
    }
  }

  void goToPreviousWeek() {
    _focusedWeekStartDate = _focusedWeekStartDate.subtract(const Duration(days: 7));
    _selectedDate = null; // Optionally clear selection when changing week
    notifyListeners();
  }

  void goToNextWeek() {
    _focusedWeekStartDate = _focusedWeekStartDate.add(const Duration(days: 7));
    _selectedDate = null; // Optionally clear selection when changing week
    notifyListeners();
  }

  void goToNextDay() {
    if (_selectedDate == null) {
      return; // Or handle as appropriate for your app's logic
    }
    setSelectedDate(_selectedDate!.add(const Duration(days: 1)));
  }

  void goToPreviousDay() {
    if (_selectedDate == null) {
      return; 
    }
    setSelectedDate(_selectedDate!.subtract(const Duration(days: 1)));
  }
}
