import 'package:flutter/material.dart';
import 'package:habit_tracker/data/models/habit.dart';
import 'package:habit_tracker/data/repositories/habit_manager.dart';
import 'dart:developer';
import 'package:habit_tracker/screens/habit_tabs_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSampleHabits();
  runApp(const MyApp());
}

Future<void> initializeSampleHabits() async {
  List<Habit> existingHabits = await HabitManager.loadHabits();
  if (existingHabits.isEmpty) {
    List<Habit> sampleHabits = [
      Habit(name: 'Exercise'),
      Habit(name: 'Meditate'),
      Habit(name: 'Read a book'),
    ];

    for (Habit habit in sampleHabits) {
      await habit.saveHabit();
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
      home: const HabitTabsScreen(),
    );
  }
}
