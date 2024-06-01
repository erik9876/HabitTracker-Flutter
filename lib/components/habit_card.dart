import 'package:flutter/material.dart';
import 'package:habit_tracker/data/models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(habit.name),
        ),
      ),
    );
  }
}
