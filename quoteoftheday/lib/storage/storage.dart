import 'package:quoteoftheday/models/quote.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Storage {
  late Database db;

  Future open() async {
    // databaseFactory = databaseFactoryFfi;
    db = await openDatabase(
      join(await getDatabasesPath(), 'quotes_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE quote(id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT, author TEXT)',
        );
      },
      version: 1,
    );
  }

  addQuote(Quote quot) async {
    await open();
    await db.insert('quote', quot.toMap());
  }

  Future<List<Quote>> getQuotes() async {
    await open();
    final List<Map<String, dynamic>> maps = await db.query('quote');

    return List.generate(maps.length, (i) {
      return Quote(
        content: maps[i]['content'],
        author: maps[i]['author'],
      );
    });
  }

  Future close() async {
    await db.close();
  }

  remove(Quote quote) async {
    await open();
    await db.rawQuery('DELETE FROM quote WHERE content = ?', [quote.content]);
  }
}
