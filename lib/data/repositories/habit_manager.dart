import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:habit_tracker/data/models/habit.dart';

class HabitManager {
  static final HabitManager _instance = HabitManager._internal();
  static Database? _db;

  String habitsTable = 'habit_table';
  String colId = 'id';
  String colName = 'name';
  String colCompletedDates = 'completed_dates';
  String colPosition = 'position';
  String colColor = 'color';

  HabitManager._internal();

  factory HabitManager() {
    return _instance;
  }

  Future<Database?> get db async {
    _db ??= await _initDb();
    return _db;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'habits.db');
    final habitsDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return habitsDb;
  }

  void _createDb(Database db, int version) async {
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

  Future<int> insertHabit(Habit habit) async {
    Database? db = await this.db;

    var existingHabit = await db!.query(
      habitsTable,
      where: '$colId = ?',
      whereArgs: [habit.id],
    );

    if (existingHabit.isNotEmpty) {
      return await updateHabit(habit);
    }

    final int result = await db.insert(habitsTable, habit.toMap());
    return result;
  }

  Future<int> updateHabit(Habit habit) async {
    Database? db = await this.db;
    final int result = await db!.update(
      habitsTable,
      habit.toMap(),
      where: '$colId = ?',
      whereArgs: [habit.id],
    );
    return result;
  }

  Future<int> deleteHabit(String id) async {
    Database? db = await this.db;
    final int result = await db!.delete(
      habitsTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<List<Habit>> getHabits() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> habitsMapList =
        await db!.query(habitsTable);
    final List<Habit> habitsList =
        habitsMapList.map((habitMap) => Habit.fromMap(habitMap)).toList();
    habitsList.sort((a, b) => a.position.compareTo(b.position));
    return habitsList;
  }
}
