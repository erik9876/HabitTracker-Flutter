import 'dart:developer';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Habit {
  final String id;
  String name;
  List<DateTime> completedDates;

  Habit({required this.name, List<DateTime>? completedDates, String? id})
      : id = id ?? const Uuid().v4(),
        completedDates = completedDates ??
            [
              DateTime(2024, 5, 31),
              DateTime(2024, 5, 30),
              DateTime(2024, 5, 29),
              DateTime(2024, 5, 28),
              DateTime(2024, 5, 27),
              DateTime(2024, 5, 26),
              DateTime(2024, 5, 25),
              DateTime(2024, 5, 24),
            ];

  void completeHabit() {
    // Add the current date to the completedDates list

    DateTime today = truncateDate(DateTime.now());

    if (!completedDates.contains(today)) {
      completedDates.add(today);
      completedDates.sort();
      saveHabit();
    } else {
      log('Habit already completed today');
    }
  }

  Future<void> saveHabit() async {
    // Save the habit to the local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> habits = prefs.getStringList('habits') ?? [];

    // Remove the existing habit if present
    habits.removeWhere((habit) => Habit.fromJson(jsonDecode(habit)).id == id);

    // Add the updated habit
    habits.add(jsonEncode(toJson()));

    await prefs.setStringList('habits', habits);
    log('Habit saved: $name');
  }

  Future<void> deleteHabit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> habits = prefs.getStringList('habits') ?? [];

    habits.removeWhere((habit) => Habit.fromJson(jsonDecode(habit)).id == id);

    await prefs.setStringList('habits', habits);
    log('Habit deleted: $name');
  }

  static DateTime truncateDate(DateTime date) {
    // Truncate the date to the day
    return DateTime(date.year, date.month, date.day);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'completedDates':
          completedDates.map((date) => date.toIso8601String()).toList(),
    };
  }

  static Habit fromJson(Map<String, dynamic> json) {
    return Habit(
      name: json['name'],
      completedDates: (json['completedDates'] as List<dynamic>)
          .map((date) => truncateDate(DateTime.parse(date)))
          .toList(),
      id: json['id'],
    );
  }
}
