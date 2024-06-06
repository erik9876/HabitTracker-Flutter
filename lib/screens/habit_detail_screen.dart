import 'package:flutter/material.dart';
import 'package:habit_tracker/components/habit_streak.dart';
import 'package:habit_tracker/data/models/habit.dart';
import 'package:habit_tracker/components/custom_calendar.dart';
import 'package:habit_tracker/components/total_days.dart';
import 'package:habit_tracker/data/services/habit_manager.dart';
import 'package:habit_tracker/main.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  late DateTime _currentMonth;

  final IHabitManager _habitManager = getIt<IHabitManager>();

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  void _completeHabit() async {
    await _habitManager.completeHabit(widget.habit);

    setState(() {
      widget.habit;
    });
  }

  void _onDayLongPressedCallback() {
    setState(() {});
  }

  void _onMonthSwitchedCallback(DateTime newMonth) {
    setState(() {
      _currentMonth = newMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.habit.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              HabitStreak(habit: widget.habit),
            ],
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TotalDays(
                  habit: widget.habit,
                  date: _currentMonth,
                ),
                CustomCalendar(
                  habit: widget.habit,
                  onDayLongPressed: _onDayLongPressedCallback,
                  onMonthSwitched: _onMonthSwitchedCallback,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _completeHabit,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                    return widget.habit.isDateCompleted(DateTime.now())
                        ? Colors.white.withOpacity(0.1)
                        : widget.habit.color;
                  },
                ),
                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                    return widget.habit.isDateCompleted(DateTime.now())
                        ? Colors.white
                        : Colors.black;
                  },
                ),
              ),
              child: Text(
                widget.habit.isDateCompleted(DateTime.now())
                    ? 'Already done'
                    : 'Complete for today',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
