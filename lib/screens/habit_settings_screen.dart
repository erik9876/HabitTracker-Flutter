import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:habit_tracker/data/models/habit.dart';
import 'package:habit_tracker/data/services/habit_manager.dart';
import 'package:habit_tracker/main.dart';

class HabitSettingsScreen extends StatefulWidget {
  final Habit habit;

  const HabitSettingsScreen({super.key, required this.habit});

  @override
  State<HabitSettingsScreen> createState() => _HabitSettingsScreenState();
}

class _HabitSettingsScreenState extends State<HabitSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _habitNameController = TextEditingController();

  final IHabitManager _habitManager = getIt<IHabitManager>();

  Color? _currentColor;

  @override
  void initState() {
    super.initState();
    _habitNameController.text = widget.habit.name;
  }

  @override
  void dispose() {
    _habitNameController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    widget.habit.name = _habitNameController.text;
    if (_currentColor != null) {
      widget.habit.color = _currentColor!;
    }
    await _habitManager.update(widget.habit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _habitNameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid name.';
                  }
                  return null;
                },
              ),
              const Spacer(),
              const Text('Color'),
              const SizedBox(height: 10),
              ColorPicker(
                pickerColor: widget.habit.color,
                onColorChanged: (Color color) => _currentColor = color,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveSettings();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Settings'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
