import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker/data/models/habit.dart';

class HabitManager {
  static Future<List<Habit>> loadHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> habits = prefs.getStringList('habits') ?? [];
    List<Habit> habitList =
        habits.map((habit) => Habit.fromJson(jsonDecode(habit))).toList();

    habitList.sort((a, b) => a.position.compareTo(b.position));

    return habitList;
  }

  static Future<void> saveHabitOrder(List<Habit> habits) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> habitStrings =
        habits.map((habit) => jsonEncode(habit.toJson())).toList();
    await prefs.setStringList('habits', habitStrings);
  }
}
