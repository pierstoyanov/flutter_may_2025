import 'package:flutter/material.dart';

class ViewToggleFAB extends StatelessWidget {
  final Object? heroTag;
  const ViewToggleFAB({super.key, this.heroTag});

  void _showViewOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text('Select View'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext); // Close the dialog
                Navigator.pushNamed(context, '/week-view');
              },
              child: const ListTile(
                leading: Icon(Icons.calendar_view_week),
                title: Text('Week View'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext); // Close the dialog
                Navigator.pushNamed(context, '/day-view');
              },
              child: const ListTile(
                leading: Icon(Icons.calendar_view_day),
                title: Text('Day View'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showViewOptionsDialog(context),
      tooltip: 'Change View',
      child: const Icon(Icons.calendar_today), // Calendar icon
      heroTag: heroTag,
    );
  }
}