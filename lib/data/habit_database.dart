import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/habit.dart';

class HabitDatabase {
  static const _databaseName = 'personal_habit.db';
  static const _databaseVersion = 1;
  static const _habitsTable = 'habits';
  static const _dailyStatusesTable = 'habit_daily_statuses';

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
        await db.execute('DROP TABLE IF EXISTS $_dailyStatusesTable');
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
    await db.delete(
      _dailyStatusesTable,
      where: 'habitId = ?',
      whereArgs: [habitId],
    );
    await db.delete(_habitsTable, where: 'id = ?', whereArgs: [habitId]);
  }

  Future<List<String>> getCompletedDates(String habitId) async {
    final db = await database;
    final rows = await db.query(
      _dailyStatusesTable,
      columns: ['statusDate'],
      where: 'habitId = ? AND isCompleted = ?',
      whereArgs: [habitId, 1],
      orderBy: 'statusDate DESC',
    );
    return rows.map((row) => row['statusDate'] as String).toList();
  }

  Future<void> ensureDailyStatuses(List<Habit> habits, String today) async {
    if (habits.isEmpty) return;

    final db = await database;
    final latestRows = await db.query(
      _dailyStatusesTable,
      columns: ['statusDate'],
      orderBy: 'statusDate DESC',
      limit: 1,
    );

    final datesToEnsure = <String>{today};
    if (latestRows.isNotEmpty) {
      final latestDate = _parseDateKey(
        latestRows.first['statusDate'] as String,
      );
      final todayDate = _parseDateKey(today);

      var date = latestDate.add(const Duration(days: 1));
      while (!date.isAfter(todayDate)) {
        datesToEnsure.add(_dateKey(date));
        date = date.add(const Duration(days: 1));
      }
    }

    final batch = db.batch();
    for (final date in datesToEnsure) {
      for (final habit in habits) {
        batch.insert(_dailyStatusesTable, {
          'id': '${habit.id}_$date',
          'habitId': habit.id,
          'statusDate': date,
          'isCompleted': 0,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }
    await batch.commit(noResult: true);
  }

  Future<void> saveDailyStatus({
    required String habitId,
    required String date,
    required bool isCompleted,
  }) async {
    final db = await database;

    await db.insert(_dailyStatusesTable, {
      'id': '${habitId}_$date',
      'habitId': habitId,
      'statusDate': date,
      'isCompleted': isCompleted ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> isHabitCompletedOnDate(String habitId, String date) async {
    final db = await database;

    final rows = await db.query(
      _dailyStatusesTable,
      where: 'habitId = ? AND statusDate = ? AND isCompleted = ?',
      whereArgs: [habitId, date, 1],
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

    await _createDailyStatusesTable(db);
  }

  Future<void> _createDailyStatusesTable(Database db) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $_dailyStatusesTable (
      id TEXT PRIMARY KEY,
      habitId TEXT NOT NULL,
      statusDate TEXT NOT NULL,
      isCompleted INTEGER NOT NULL,
      UNIQUE(habitId, statusDate)
    )
  ''');
  }

  DateTime _parseDateKey(String dateKey) {
    final parts = dateKey.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }
}
