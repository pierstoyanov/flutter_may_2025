import 'package:flutter/material.dart';

// CalendarProvider: Manages the displayed month and selected date state
class CalendarProvider extends ChangeNotifier {
  DateTime _currentMonth;
  DateTime? _selectedDate;

  CalendarProvider(DateTime initialDate):
    _currentMonth = DateTime(initialDate.year, initialDate.month, 1),
    _selectedDate = initialDate;

  DateTime get currentMonth => _currentMonth;
  DateTime? get selectedDate => _selectedDate;

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
    _selectedDate = date;
    notifyListeners();
  }
}
