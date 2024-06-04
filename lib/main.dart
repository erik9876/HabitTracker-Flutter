import 'package:flutter/material.dart';
import 'package:habit_tracker/data/models/habit.dart';
import 'package:habit_tracker/data/repositories/habit_manager.dart';
import 'package:habit_tracker/screens/habit_list_screen.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSampleHabits();
  runApp(const MyApp());
}

Future<void> initializeSampleHabits() async {
  List<Habit> existingHabits = await HabitManager().getHabits();
  if (existingHabits.isEmpty) {
    List<Habit> sampleHabits = [
      Habit(name: 'Exercise', position: 1),
      Habit(name: 'Meditate', position: 2),
      Habit(name: 'Read a book', position: 3),
    ];

    for (Habit habit in sampleHabits) {
      habit.save();
    }
    log('Sample habits initialized.');
  } else {
    log('Habits already exist.');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Montserrat',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
      ),
      themeMode: ThemeMode.system,
      home: const HabitListScreen(),
    );
  }
}
