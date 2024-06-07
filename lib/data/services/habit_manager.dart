import 'package:habit_tracker/data/helper/datetime_helper.dart';
import 'package:habit_tracker/data/repositories/habit_repository.dart';
import 'package:habit_tracker/main.dart';
import 'package:habit_tracker/data/models/habit.dart';
import 'dart:developer';

abstract class IHabitManager {
  // Wrapper methods for potential validation
  Future<Habit> create(String name, int position);
  Future<void> delete(Habit habit);
  Future<void> update(Habit habit);
  Future<List<Habit>> getHabits();
  Future<void> completeHabit(Habit habit);
  Future<void> togglePastDate(Habit habit, DateTime date);
  Future<void> updatePosition(Habit habit, int position);
}

class HabitManager implements IHabitManager {
  final IHabitRepository _repository = getIt<IHabitRepository>();

  @override
  Future<Habit> create(String name, int position) async {
    var habit = Habit(name: name, position: position);
    await _repository.create(habit);
    return habit;
  }

  @override
  Future<void> delete(Habit habit) async {
    await _repository.delete(habit);
  }

  @override
  Future<void> update(Habit habit) async {
    await _repository.update(habit);
  }

  @override
  Future<List<Habit>> getHabits() async {
    var habits = await _repository.getAll();
    for (var habit in habits) {
      habit.calculateStreak();
    }
    return habits;
  }

  @override
  Future<void> completeHabit(Habit habit) async {
    DateTime today = DateTime.now();
    if (!habit.isDateCompleted(today)) {
      habit.addDate(today);
      await _repository.update(habit);
    } else {
      log('Habit already completed today');
    }
  }

  @override
  Future<void> togglePastDate(Habit habit, DateTime date) async {
    bool isFutureDate = date.isAfter(DateTime.now()) ||
        truncateDate(date) == truncateDate(DateTime.now());

    if (isFutureDate) {
      log('You can only toggle past dates');
      return;
    }

    if (habit.isDateCompleted(date)) {
      habit.removeDate(date);
    } else {
      habit.addDate(date);
    }

    await _repository.update(habit);
  }

  @override
  Future<void> updatePosition(Habit habit, int position) async {
    if (position < 0 || habit.position == position) {
      return;
    }

    habit.position = position;
    await _repository.update(habit);
  }
}
