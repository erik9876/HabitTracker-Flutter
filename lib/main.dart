import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_tracker/data/models/habit.dart';
import 'package:habit_tracker/data/repositories/habit_repository.dart';
import 'package:habit_tracker/data/services/habit_manager.dart';
import 'package:habit_tracker/screens/habit_list_screen.dart';
import 'dart:developer';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var habitRepository = SqfLiteHabitRepository();
  await habitRepository.initDb();

  getIt.registerSingleton<IHabitRepository>(habitRepository);
  getIt.registerSingleton<IHabitManager>(HabitManager());

  await initializeSampleHabits(habitRepository);
  runApp(const MyApp());
}

Future<void> initializeSampleHabits(IHabitRepository repository) async {
  List<Habit> existingHabits = await repository.getAll();
  if (existingHabits.isEmpty) {
    List<Habit> sampleHabits = [
      Habit(name: 'Exercise', position: 1),
      Habit(name: 'Meditate', position: 2),
      Habit(name: 'Read a book', position: 3),
    ];

    for (Habit habit in sampleHabits) {
      await repository.create(habit);
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
