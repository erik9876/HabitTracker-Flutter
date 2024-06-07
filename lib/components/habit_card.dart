import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_streak.dart';
import 'package:habit_tracker/data/models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Container(
        height: 70,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.circle,
                  color: habit.color,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(habit.name),
              ],
            ),
            trailing: SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  HabitStreak(habit: habit),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
