import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/calendar_provider.dart';
import 'package:flutter_application_1/widgets/month_callendar/month_calendar_element.dart';

class MonthCalendarCarousel extends StatefulWidget {
  // This widget handles horisontal swiping of Month Callendar Elemnents
  final DateTime initialDate;
  final ValueChanged<DateTime>? onDateSelected;
  final Color? selectedDayColor;
  final Color? todayColor;
  final Color? dayTextColor;
  final Color? weekendTextColor;
  final Color? headerTextColor;
  final double? dayFontSize;
  final double? headerFontSize;

  const MonthCalendarCarousel({
    super.key,
    required this.initialDate,
    this.onDateSelected,
    this.selectedDayColor,
    this.todayColor,
    this.dayTextColor,
    this.weekendTextColor,
    this.headerTextColor,
    this.dayFontSize,
    this.headerFontSize,
  });

  @override
  _MonthCalendarCarouselState createState() => _MonthCalendarCarouselState();
}

class _MonthCalendarCarouselState extends State<MonthCalendarCarousel> {
  late PageController _pageController;

  // We need a base date to calculate page index.
  final DateTime _minDate = DateTime(1900, 1, 1);
  final DateTime _maxDate = DateTime(2100, 12, 31); // A reasonable future limit

  @override
  void initState() {
    super.initState();

    // Initialize _pageController directly using widget.initialDate.
    // widget.initialDate is sourced from the CalendarProvider.currentMonth
    // when this widget is created by its parent.
    int initialPageIndex = _getMonthDifference(_minDate, widget.initialDate);
    _pageController = PageController(initialPage: initialPageIndex);
    _pageController.addListener(_handlePageScroll);
  }


  void _handlePageScroll() {
    if (_pageController.page == _pageController.page!.roundToDouble()) {
      // Only update provider when page has fully settled on a new index
      final int newIndex = _pageController.page!.round();
      final DateTime newMonth = _getMonthForPageIndex(newIndex);
      final calendarProvider = context.read<CalendarProvider>(); // HERE could be trouble
      if (newMonth.year != calendarProvider.currentMonth.year ||
          newMonth.month != calendarProvider.currentMonth.month) {
        calendarProvider.setCurrentMonth(newMonth);
      }
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageScroll);
    _pageController.dispose();
    super.dispose();
  }

  // Helper to calculate the difference in months between two dates
  int _getMonthDifference(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + to.month - from.month;
  }

  // Helper to get the month for a given page index
  DateTime _getMonthForPageIndex(int index) {
    return DateTime(_minDate.year, _minDate.month + index, 1);
  }

  @override
  Widget build(BuildContext context) {
    // Initial page index must be calculated only once or when initialDate changes.
    // In this setup, it's calculated in initState and managed by PageController.
    // We are now listening to the provider's `currentMonth` to update the header.
    final calendarProvider = context.watch<CalendarProvider>();

    // Synchronize PageView with CalendarProvider's currentMonth.
    // This ensures that if currentMonth changes in the provider (e.g., after button press
    // or external update), the PageView animates to the correct month.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // Ensure widget is still in the tree
      if (_pageController.hasClients) {
        final int targetPageIndex = _getMonthDifference(_minDate, calendarProvider.currentMonth);
        // Only animate if the PageView is settled on a different page than the target.
        // _pageController.page can be null before layout or fractional during scroll.
        if (_pageController.page != null &&
            _pageController.page!.round() != targetPageIndex &&
            _pageController.page == _pageController.page!.roundToDouble()) { // Check if settled
          _pageController.animateToPage(
            targetPageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });


    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month navigation header (outside the PageView)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon buttons act the same as swiping
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  if (_pageController.hasClients) {
                    int currentPageIndex = _pageController.page?.round() ?? _pageController.initialPage;
                    if (currentPageIndex > 0) {
                      _pageController.animateToPage(
                        currentPageIndex - 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  }
                },
              ),
              Text(
                DateFormat.yMMMM().format(calendarProvider.currentMonth),
                style: TextStyle(
                  fontSize: widget.headerFontSize != null ? widget.headerFontSize! + 4 : 20,
                  fontWeight: FontWeight.bold,
                  color: widget.headerTextColor ?? Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  if (_pageController.hasClients) {
                    int currentPageIndex = _pageController.page?.round() ?? _pageController.initialPage;
                    int maxPageIndex = _getMonthDifference(_minDate, _maxDate);
                    if (currentPageIndex < maxPageIndex) {
                      _pageController.animateToPage(
                        currentPageIndex + 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  }
                },
              ),
            ],
          ),
          const Divider(height: 10),
          SizedBox(
            height: 350, // ADJUST FOR 5 vs 6 ROWS 
            child: PageView.builder(
              controller: _pageController,
              // No need for onPageChanged directly, as _handlePageScroll will update provider
              itemBuilder: (context, index) {
                final DateTime monthToDisplay = _getMonthForPageIndex(index);
                return MonthCalendarElement(
                  initialDate: monthToDisplay,
                  // Pass the selected date from the provider
                  selectedDate: calendarProvider.selectedDate,
                  // When a date is selected in MonthCalendar, update the provider
                  onDateSelected: (date) {
                    calendarProvider.setSelectedDate(date);
                    widget.onDateSelected?.call(date); // Pass it up to the parent
                  },
                  selectedDayColor: widget.selectedDayColor,
                  todayColor: widget.todayColor,
                  dayTextColor: widget.dayTextColor,
                  weekendTextColor: widget.weekendTextColor,
                  headerTextColor: widget.headerTextColor,
                  dayFontSize: widget.dayFontSize,
                  headerFontSize: widget.headerFontSize,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}