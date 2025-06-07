import 'package:flutter/material.dart';

class CalendarProvider extends ChangeNotifier {
  DateTime _currentMonth;
  DateTime? _selectedDate;

  CalendarProvider(DateTime initialDate):
    _currentMonth = DateTime(initialDate.year, initialDate.month, 1),
    _selectedDate = initialDate;

  // getters
  DateTime get currentMonth => _currentMonth;
  DateTime? get selectedDate => _selectedDate;

  // setters
  void setCurrentMonth(DateTime month) {
    _currentMonth = DateTime(month.year, month.month, 1);
    _selectedDate = null; // Decide if you want to clear selection on programmatic month change
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // helper fn
  void goToPreviousMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    _selectedDate = null; // Clear selected date
    notifyListeners();
  }

  void goToNextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    _selectedDate = null; // Clear selected date
    notifyListeners();
  }
}