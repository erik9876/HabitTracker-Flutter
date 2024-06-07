import 'dart:convert';
import 'dart:math' as math;
import 'package:habit_tracker/data/helper/datetime_helper.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class Habit {
  final String id;
  String name;
  List<DateTime> completedDates;
  Color color;
  int position;

  int streak = 0;

  Habit(
      {required this.name,
      List<DateTime>? completedDates,
      String? id,
      required this.position,
      Color? color})
      : id = id ?? const Uuid().v4(),
        completedDates = completedDates ?? [],
        color = color ?? getRandomColor() {
    calculateStreak();
  }

  static Color getRandomColor() {
    final random = math.Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  void addDate(DateTime date) {
    date = truncateDate(date);
    if (!completedDates.contains(date)) {
      completedDates.add(date);
      completedDates.sort();
      calculateStreak();
    }
  }

  void removeDate(DateTime date) {
    date = truncateDate(date);
    if (completedDates.contains(date)) {
      completedDates.remove(date);
      calculateStreak();
    }
  }

  void calculateStreak() {
    DateTime today = truncateDate(DateTime.now());
    int streakCount = completedDates.contains(today) ? 1 : 0;
    DateTime yesterday = truncateDate(today.subtract(const Duration(days: 1)));
    while (completedDates.contains(yesterday)) {
      streakCount += 1;
      yesterday = truncateDate(yesterday.subtract(const Duration(days: 1)));
    }
    streak = streakCount;
  }

  int getTotalCompletedDatesInMonth(DateTime date) {
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 0);
    DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 1);
    return completedDates
        .where((completedDate) =>
            completedDate.isAfter(firstDayOfMonth) &&
            completedDate.isBefore(lastDayOfMonth))
        .length;
  }

  bool isDateCompleted(DateTime date) {
    var truncatedDate = truncateDate(date);
    return completedDates.contains(truncatedDate);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'completed_dates': jsonEncode(
          completedDates.map((date) => date.toIso8601String()).toList()),
      'position': position,
      'color': color.value,
    };
  }

  static Habit fromMap(Map<String, dynamic> map) {
    return Habit(
      name: map['name'],
      completedDates: (jsonDecode(map['completed_dates']) as List<dynamic>)
          .map((date) => DateTime.parse(date))
          .toList(),
      id: map['id'],
      position: map['position'],
      color: Color(map['color']),
    );
  }
}
