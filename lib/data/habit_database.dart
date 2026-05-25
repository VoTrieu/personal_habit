import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/habit.dart';

class HabitDatabase {
  static const _databaseName = 'personal_habit.db';
  static const _databaseVersion = 3;
  static const _habitsTable = 'habits';
  static const _completionsTable = 'habit_completions';

  Database? _database;

  Future<Database> get database async {
    final existingDatabase = _database;
    if (existingDatabase != null) {
      return existingDatabase;
    }

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    final database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) {
        return _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS $_habitsTable');
        await _createTables(db);
      },
    );

    _database = database;
    return database;
  }

  Future<List<Habit>> getHabits() async {
    final db = await database;
    final habits = await db.query(_habitsTable);
    return habits.map((habit) => Habit.fromMap(habit)).toList();
  }

  Future<void> insertHabit(Habit habit) async {
    final db = await database;
    await db.insert(_habitsTable, habit.toMap());
  }

  Future<void> updateHabit(Habit habit) async {
    final db = await database;
    await db.update(
      _habitsTable,
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<void> deleteHabit(String habitId) async {
    final db = await database;
    await db.delete(_habitsTable, where: 'id = ?', whereArgs: [habitId]);
  }

  Future<List<String>> getCompletedDates(String habitId) async {
    final db = await database;
    final rows = await db.query(
      _completionsTable,
      columns: ['completedDate'],
      where: 'habitId = ?',
      whereArgs: [habitId],
      orderBy: 'completedDate DESC',
    );
    return rows.map((row) => row['completedDate'] as String).toList();
  }

  Future<void> insertCompletion(String habitId, String date) async {
    final db = await database;

    await db.insert(_completionsTable, {
      'id': '${habitId}_$date',
      'habitId': habitId,
      'completedDate': date,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> deleteCompletion(String habitId, String date) async {
    final db = await database;

    await db.delete(
      _completionsTable,
      where: 'habitId = ? AND completedDate = ?',
      whereArgs: [habitId, date],
    );
  }

  Future<bool> isHabitCompletedOnDate(String habitId, String date) async {
    final db = await database;

    final rows = await db.query(
      _completionsTable,
      where: 'habitId = ? AND completedDate = ?',
      whereArgs: [habitId, date],
      limit: 1,
    );

    return rows.isNotEmpty;
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
    CREATE TABLE $_habitsTable (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      iconCodePoint INTEGER NOT NULL,
      isCompletedToday INTEGER NOT NULL,
      streak INTEGER NOT NULL,
      colorValue INTEGER NOT NULL,
      frequency TEXT NOT NULL,
      reminderEnabled INTEGER NOT NULL,
      reminderTimeMinutes INTEGER NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE $_completionsTable (
      id TEXT PRIMARY KEY,
      habitId TEXT NOT NULL,
      completedDate TEXT NOT NULL,
      UNIQUE(habitId, completedDate)
    )
  ''');
  }
}
