import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/data/models/habit.dart';

class HabitStreak extends StatelessWidget {
  final Habit habit;

  const HabitStreak({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(habit.getStreakDays().toString(), style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        const Icon(CupertinoIcons.flame, size: 22, color: Colors.orange),
      ],
    );
  }
}