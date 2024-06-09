import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_streak.dart';
import 'package:habit_tracker/data/models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final bool borderRounded;

  const HabitCard(
      {super.key, required this.habit, required this.borderRounded});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRounded ? BorderRadius.circular(12) : null,
        color: Colors.white.withOpacity(0.1),
      ),
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
    );
  }
}
