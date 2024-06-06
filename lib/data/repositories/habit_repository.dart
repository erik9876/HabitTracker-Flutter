import 'dart:async';
import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:habit_tracker/data/models/habit.dart';

abstract class IHabitRepository {
  Future<bool> create(Habit habit);
  Future<bool> update(Habit habit);
  Future<bool> delete(Habit habit);
  Future<List<Habit>> getAll();
}

class SqfLiteHabitRepository implements IHabitRepository, Disposable {
  Database? _db;

  String habitsTable = 'habit_table';
  String colId = 'id';
  String colName = 'name';
  String colCompletedDates = 'completed_dates';
  String colPosition = 'position';
  String colColor = 'color';

  Future<void> initDb() async {
    String path = join(await getDatabasesPath(), 'habits.db');
    _db = await openDatabase(path, version: 1, onCreate: _initializeTables);
  }

  Future<void> _initializeTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $habitsTable(
        $colId TEXT PRIMARY KEY,
        $colName TEXT,
        $colCompletedDates TEXT,
        $colPosition INTEGER,
        $colColor INTEGER
      )
    ''');
  }

  @override
  FutureOr onDispose() {
    if (_db != null) {
      _db!.close();
    }
  }

  @override
  Future<bool> create(Habit habit) async {
    if (_db == null) {
      throw Exception('Database not initialized.');
    }

    try {
      var existingHabit = await _db!.query(
        habitsTable,
        where: '$colId = ?',
        whereArgs: [habit.id],
      );

      if (existingHabit.isNotEmpty) {
        return await update(habit);
      }

      final int result = await _db!.insert(habitsTable, habit.toMap());
      return result >= 0;
    } catch (ex) {
      log('$ex');
      return false;
    }
  }

  @override
  Future<bool> delete(Habit habit) async {
    if (_db == null) {
      throw Exception('Database not initialized.');
    }

    try {
      final int result = await _db!.delete(
        habitsTable,
        where: '$colId = ?',
        whereArgs: [habit.id],
      );
      return result >= 0;
    } catch (ex) {
      log('$ex');
      return false;
    }
  }

  @override
  Future<List<Habit>> getAll() async {
    if (_db == null) {
      throw Exception('Database not initialized.');
    }

    try {
      final List<Map<String, dynamic>> habitsMapList =
          await _db!.query(habitsTable);
      final List<Habit> habitsList =
          habitsMapList.map((habitMap) => Habit.fromMap(habitMap)).toList();

      habitsList.sort((a, b) => a.position.compareTo(b.position));
      return habitsList;
    } catch (ex) {
      log('$ex');
      return [];
    }
  }

  @override
  Future<bool> update(Habit habit) async {
    if (_db == null) {
      throw Exception('Database not initialized.');
    }

    try {
      final int result = await _db!.update(
        habitsTable,
        habit.toMap(),
        where: '$colId = ?',
        whereArgs: [habit.id],
      );
      return result >= 0;
    } catch (ex) {
      log('$ex');
      return false;
    }
  }
}
