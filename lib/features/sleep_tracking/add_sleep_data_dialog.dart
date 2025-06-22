import 'package:flutter/material.dart';

class AddSleepDataDialog extends StatefulWidget {
  final void Function(Map<String, dynamic>) onAdd;
  const AddSleepDataDialog({super.key, required this.onAdd});

  @override
  State<AddSleepDataDialog> createState() => _AddSleepDataDialogState();
}

class _AddSleepDataDialogState extends State<AddSleepDataDialog> {
  final _formKey = GlobalKey<FormState>();
  final _sleepTimeController = TextEditingController();
  final _wakeTimeController = TextEditingController();
  final _qualityController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Sleep Data'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _sleepTimeController,
                decoration: const InputDecoration(labelText: 'Sleep Time (e.g. 22:30)'),
                validator: (value) => value == null || value.isEmpty ? 'Enter sleep time' : null,
              ),
              TextFormField(
                controller: _wakeTimeController,
                decoration: const InputDecoration(labelText: 'Wake Time (e.g. 06:30)'),
                validator: (value) => value == null || value.isEmpty ? 'Enter wake time' : null,
              ),
              TextFormField(
                controller: _qualityController,
                decoration: const InputDecoration(labelText: 'Quality (1-5)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Enter quality' : null,
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAdd({
                'sleepTime': _sleepTimeController.text,
                'wakeTime': _wakeTimeController.text,
                'quality': _qualityController.text,
                'notes': _notesController.text,
                'date': DateTime.now(),
              });
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
