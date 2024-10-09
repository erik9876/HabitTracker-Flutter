import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_streak.dart';
import 'package:habit_tracker/components/week_calendar.dart';
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
        borderRadius: borderRounded
            ? BorderRadius.circular(12)
            : const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
        color: Colors.white.withOpacity(0.1),
      ),
      height: 100,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
        child: Column(children: [
          ListTile(
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
          WeekCalendar(
            habit: habit,
          ),
        ]),
      ),
    );
  }
}
