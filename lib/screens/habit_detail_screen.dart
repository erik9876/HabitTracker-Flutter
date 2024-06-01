import 'package:flutter/material.dart';
import 'package:habit_tracker/data/models/habit.dart';
import 'package:habit_tracker/components/custom_calendar.dart'; // Importieren Sie die CustomCalendar

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  void _completeHabit() {
    setState(() {
      widget.habit.completeHabit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.name),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Habit ID: ${widget.habit.id}',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Text('Name: ${widget.habit.name}',
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                const Text('Completed Dates:', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                Card(
                  child: CustomCalendar(habit: widget.habit),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _completeHabit,
              child: const Text('Done today'),
            ),
          ),
        ],
      ),
    );
  }
}
