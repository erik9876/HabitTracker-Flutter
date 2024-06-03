import 'dart:developer';
import 'dart:convert';
import 'dart:math' as math;
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Habit {
  final String id;
  String name;
  List<DateTime> completedDates;
  Color color;

  Habit({required this.name, List<DateTime>? completedDates, String? id})
      : id = id ?? const Uuid().v4(),
        completedDates = completedDates ?? [],
        color = getRandomColor();

  static Color getRandomColor() {
    final random = math.Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  int getStreakDays() {
    DateTime today = truncateDate(DateTime.now());
    int streakCount = completedDates.contains(today) ? 1 : 0;
    DateTime yesterday = truncateDate(today.subtract(const Duration(days: 1)));
    while (completedDates.contains(yesterday)) {
      streakCount += 1;
      yesterday = truncateDate(yesterday.subtract(const Duration(days: 1)));
    }
    return streakCount;
  }

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

  bool isDateCompleted(DateTime date) {
    var truncatedDate = truncateDate(date);
    return completedDates.contains(truncatedDate);
  }

  void completeForgottenHabit(DateTime date) {
    // Add the given date to the completedDates list

    date = truncateDate(date);
    if (!completedDates.contains(date) &&
        date.isBefore(truncateDate(DateTime.now()))) {
      completedDates.add(date);
      completedDates.sort();
      saveHabit();
    } else {
      log('Habit already completed on $date');
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
