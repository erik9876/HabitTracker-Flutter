import 'package:flutter/material.dart';
import 'package:habit_tracker/data/models/habit.dart';

class StreakChallenge extends StatelessWidget {
  final Habit habit;

  const StreakChallenge({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 70,
        width: MediaQuery.of(context).size.width - 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "30 Day Challenge",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Day ${habit.streak % 31} of 30"),
                ],
              ),
              SizedBox(
                height: 15,
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: (habit.streak % 31) / 30,
                  color: habit.color,
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
