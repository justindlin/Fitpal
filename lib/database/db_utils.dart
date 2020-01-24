import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils {
  static Future<Database> init() async {
    return openDatabase(
      path.join(await getDatabasesPath(), 'fitness.db'),
      onCreate: (db, version) {
        if (version > 1) {
          // downgrade path
        }
        db.execute('CREATE TABLE Weight (weightID INTEGER PRIMARY KEY, datetime TEXT NOT NULL, weight REAL NOT NULL, user TEXT);');
        db.execute('CREATE TABLE Food (calorieID INTEGER PRIMARY KEY, datetime TEXT NOT NULL, mealType TEXT NOT NULL, foodName TEXT, calorieIntake INTEGER NOT NULL, user TEXT);');
        db.execute('CREATE TABLE Workout (workoutID INTEGER PRIMARY KEY, datetime TEXT NOT NULL, repeatEvery INTEGER, workoutName TEXT NOT NULL, reps INTEGER, sets INTEGER, duration INTEGER, isCompleted INTEGER NOT NULL, caloriesBurned REAL, user TEXT);');
      },
      version: 1,
    );
  }
}