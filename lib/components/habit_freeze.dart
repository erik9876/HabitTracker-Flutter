import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/data/models/habit.dart';

class HabitFreeze extends StatelessWidget {
  final Habit habit;

  const HabitFreeze({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          habit.getFreezes().toString(),
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          CupertinoIcons.snow,
          size: 30,
          color: Colors.blueGrey,
        ),
      ],
    );
  }
}
