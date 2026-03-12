import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssignmentRemindersScreen extends StatefulWidget {
  const AssignmentRemindersScreen({super.key});

  @override
  _AssignmentRemindersScreenState createState() =>
      _AssignmentRemindersScreenState();
}

class _AssignmentRemindersScreenState extends State<AssignmentRemindersScreen> {
  final List<Map<String, dynamic>> _reminders = [];
  final _titleController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _addReminder() {
    if (_titleController.text.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title and pick a date.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    setState(() {
      _reminders.add({
        'title': _titleController.text,
        'date': _selectedDate!,
      });
      _reminders.sort((a, b) => a['date'].compareTo(b['date']));
    });
    
    Navigator.of(context).pop();
  }

  // **MODIFIED:** This function now accepts a special "StateSetter"
  // to update the dialog's state.
  void _presentDatePicker(StateSetter setStateInDialog) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      // This updates the UI *inside* the dialog.
      setStateInDialog(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _showAddReminderDialog() {
    _titleController.clear();
    _selectedDate = null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Reminder'),
        // **FIX:** We use StatefulBuilder to give the dialog its own state.
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateInDialog) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration:
                      const InputDecoration(labelText: 'Assignment/Test Name'),
                  autofocus: true,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked: ${DateFormat.yMd().format(_selectedDate!)}',
                      ),
                    ),
                    TextButton(
                      // We pass the dialog's special setState function here.
                      onPressed: () => _presentDatePicker(setStateInDialog),
                      child: const Text('Choose Date'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Add'),
            onPressed: _addReminder,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Reminders'),
      ),
      body: _reminders.isEmpty
          ? const Center(
              child: Text(
              'No reminders added yet!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ))
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _reminders.length,
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: ListTile(
                    title: Text(
                      _reminders[index]['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        Text(DateFormat.yMMMd().format(_reminders[index]['date'])),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          _reminders.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddReminderDialog,
        tooltip: 'Add Reminder',
        child: const Icon(Icons.add),
      ),
    );
  }
}