import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:habit_tracker/entities/habit.dart';

class HabitDatabase {
  static const String databaseName = 'habit_database.db';
  static const String tableName = 'habits';
  static late final Future<Database> database;

  static Future<void> initDatabase() async {
    if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    database = openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (Database db, int version) {
        return db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, startDate TEXT, checkedDays TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertHabit(Habit habit) async {
    final db = await database;
    await db.insert(
      tableName,
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Habit>> getHabits() async {
    final db = await database;
    final List<Map<String, Object?>> habitMaps = await db.query('habits');
    return habitMaps.map(Habit.fromMap).toList();
  }

  Future<void> updateHabit(Habit habit) async {
    final db = await database;
    await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<void> deleteHabit(int id) async {
    final db = await database;
    await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
