import 'package:agenda/models/db/contactTable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class InitDb {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDb();
    }
    return _db!;
  }

  static Future<Database> initDb() async {
    final dataBasePath = await getDatabasesPath();
    final path = join(dataBasePath, 'contacts.db');
    return openDatabase(path, version: 1, onCreate: (Database db, int newVersion) async {
      await db.execute(
          'CREATE TABLE $contactTable('
              '$idColumn INTEGER PRIMARY KEY,'
              ' $nameColumn TEXT,'
              ' $emailColumn TEXT,'
              ' $phoneColumn TEXT,'
              ' $imgColumn TEXT)'
      );
    });
  }
}