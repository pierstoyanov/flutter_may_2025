import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/event_repository.dart';
import 'package:flutter_application_1/models/event_item.dart';
import 'package:flutter_application_1/widgets/my_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart'; 

class CreateEventScreen extends StatefulWidget {
  final String title;
  const CreateEventScreen({super.key, required this.title});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;
  bool _isLoading = false;

  Future<void> _selectDateTime(BuildContext context, bool isStartTime) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: (isStartTime ? _startTime : _endTime) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (!mounted) return;

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime((isStartTime ? _startTime : _endTime) ?? DateTime.now()),
      );

      if (!mounted) return;

      if (pickedTime != null) {
        setState(() {
          final selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isStartTime) {
            _startTime = selectedDateTime;
            // Optionally adjust end time if start time is after end time
            if (_endTime != null && _startTime!.isAfter(_endTime!)) {
              _endTime = _startTime!.add(const Duration(hours: 1));
            }
          } else {
            _endTime = selectedDateTime;
            // Optionally adjust start time if end time is before start time
            if (_startTime != null && _endTime!.isBefore(_startTime!)) {
              _startTime = _endTime!.subtract(const Duration(hours: 1));
            }
          }
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_startTime == null || _endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select start and end times.')),
        );
        return;
      }
      if (_endTime!.isBefore(_startTime!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time cannot be before start time.')),
        );
        return;
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You must be logged in to create an event.')),
        );
        return;
      }

      setState(() => _isLoading = true);

      final newEvent = EventItem(
        id: const Uuid().v4(), // Generate a unique ID
        title: _titleController.text,
        description: _descriptionController.text,
        startTime: _startTime!,
        endTime: _endTime!,
        createdBy: currentUser.uid,
        createdAt: DateTime.now(),
        // color: null, // Add color picker if needed
      );

      try {
        await Provider.of<EventRepository>(context, listen: false).addEvent(newEvent);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event created successfully!')),
          );
          Navigator.of(context).pop(); // Go back after creating
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create event: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title'), validator: (value) => value!.isEmpty ? 'Please enter a title' : null),
              TextFormField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
              const SizedBox(height: 16),
              ListTile(title: Text(_startTime == null ? 'Select Start Time' : 'Start: ${DateFormat.yMMMd().add_jm().format(_startTime!)}'), trailing: const Icon(Icons.calendar_today), onTap: () => _selectDateTime(context, true)),
              ListTile(title: Text(_endTime == null ? 'Select End Time' : 'End: ${DateFormat.yMMMd().add_jm().format(_endTime!)}'), trailing: const Icon(Icons.calendar_today), onTap: () => _selectDateTime(context, false)),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Create Event'),
                          onPressed: _submitForm,
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}