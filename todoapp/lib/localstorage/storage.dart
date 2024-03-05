import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/task.dart';

class Storage {
  late Database db;

  Future open() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'tasks_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, date TEXT, time TEXT, done INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<Task> addTask(Task task) async {
    await open();
    await db.insert('tasks', task.toMap());
    return task;
  }

  Future updateTaskStatus(id, done) async {
    // print("----------hello----------");
    await open();
    if (done) {
      await db.rawQuery('UPDATE tasks SET done = 1 where id=$id and done=0');
    } else {
      await db.rawQuery('UPDATE tasks SET done = 0 where id=$id and done=1');
    }

    // print("----------hello----------");
  }

  Future<List<Task>> getTasks() async {
    await open();
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        date: maps[i]['date'],
        time: maps[i]['time'],
        done: maps[i]['done'] == 1,
      );
    });
  }

  Future deleteTask(id) async {
    await open();
    await db.rawDelete('DELETE FROM tasks WHERE id = $id');
  }

  Future updateTask(Task task) async {
    await open();
    await db
        .update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<List<Task>> searchTasks(String query) async {
    await open();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM tasks WHERE title LIKE '%$query%' OR description LIKE '%$query%'");
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        date: maps[i]['date'],
        time: maps[i]['time'],
        done: maps[i]['done'] == 1,
      );
    });
  }

  Future close() async {
    await db.close();
  }
}
