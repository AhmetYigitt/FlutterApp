import 'dart:async';
import 'dart:io';

import 'package:flutterapp/student_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQFLiteDbContext {
  static SQFLiteDbContext? _sqfLiteDbContext;

  Database? _database;
  final String _databaseName = "schooldb.db";
  final String _studentTable = "Students";
  final String _columnId = "id";
  final String _columnName = "name";
  final String _columnIsActive = "isActive";
  final String _department = "department";

  factory SQFLiteDbContext() {
    if (_sqfLiteDbContext == null) {
      _sqfLiteDbContext = SQFLiteDbContext._internal();
      return _sqfLiteDbContext!;
    } else {
      return _sqfLiteDbContext!;
    }
  }

  SQFLiteDbContext._internal();

  Future<Database> _initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, _databaseName);
    var db = openDatabase(path, version: 1, onCreate: _createDatabase);

    return db;
  }

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database!;
    } else {
      return _database!;
    }
  }

  FutureOr<void> _createDatabase(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_studentTable($_columnId INTEGER PRIMARY KEY AUTOINCREMENT, $_columnName TEXT,$_department TEXT, $_columnIsActive INTEGER)");
  }

  FutureOr<int> insertStudent(Student student) async {
    var db = await _getDatabase();
    var result = await db.insert(_studentTable, student.toMap(),
        nullColumnHack: _columnId);

    return result;
  }

  FutureOr<int> updateStudent(Student student) async {
    var db = await _getDatabase();
    var result = await db.update(_studentTable, student.toMap(),
        where: "$_columnId= ?", whereArgs: [student.id]);

    return result;
  }

  FutureOr<int> deleteStudent(int id) async {
    var db = await _getDatabase();
    var result =
        await db.delete(_studentTable, where: "$_columnId= ?", whereArgs: [id]);

    return result;
  }

  FutureOr<Student> getStudent(int id) async {
    var db = await _getDatabase();
    var result =
        await db.query(_studentTable, where: "$_columnId= ?", whereArgs: [id]);

    return Student.fromMap(result[0]);
  }

  Future<List<Student>> getStudents() async {
    var db = await _getDatabase();
    var result = await db.query(_studentTable, orderBy: "id desc");
    List<Student> list = [];

    for (var student in result) {
      list.add(Student.fromMap(student));
    }

    return list;
  }
}
