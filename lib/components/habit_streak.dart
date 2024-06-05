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
        Text(
          habit.getStreakDays().toString(),
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(width: 4),
        Icon(CupertinoIcons.flame,
            size: 22,
            color: habit.isDateCompleted(DateTime.now())
                ? Colors.orange
                : Colors.grey),
      ],
    );
  }
}
