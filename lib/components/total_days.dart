import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:habit_tracker/data/models/habit.dart';

class TotalDays extends StatelessWidget {
  final Habit habit;
  final DateTime date;

  const TotalDays({
    super.key,
    required this.habit,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          child: SizedBox(
            height: 50,
            width: (MediaQuery.of(context).size.width * 0.5) - 27,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: habit.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    habit.getTotalCompletedDatesInMonth(date).toString(),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Card(
          child: SizedBox(
            height: 50,
            width: (MediaQuery.of(context).size.width * 0.5) - 27,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    'Want to implement Freezes?',
                    style: TextStyle(
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
