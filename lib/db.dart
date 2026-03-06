import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseClass {
  static Database? _database;
  Future<Database> get myGetter async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String dir = await getDatabasesPath();
    String path = join(dir, "local_database.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
CREATE TABLE userData(email TEXT, firstName TEXT, surName TEXT, passsword TEXT, id INTEGER PRIMARY KEY)
""");
      },
    );
  }
}
