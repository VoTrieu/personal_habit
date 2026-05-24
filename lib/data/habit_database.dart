import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/habit.dart';

class HabitDatabase {
  static const _databaseName = 'personal_habit.db';
  static const _databaseVersion = 1;
  static const _habitsTable = 'habits';

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
        return db.execute('''
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
}
